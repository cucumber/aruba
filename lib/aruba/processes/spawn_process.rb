# frozen_string_literal: true

require 'tempfile'
require 'shellwords'

require 'aruba/errors'
require 'aruba/processes/basic_process'
require 'aruba/platform'

# Aruba
module Aruba
  # Platforms
  module Processes
    # Wrapper around Process.spawn that broadly follows the ChildProcess interface
    # @private
    class ProcessRunner
      def initialize(command_array)
        @command_array = command_array
        @exit_status = nil
      end

      attr_accessor :stdout, :stderr, :cwd, :environment
      attr_reader :command_array, :pid

      def start
        @stdin_r, @stdin_w = IO.pipe
        @pid = Process.spawn(environment, *command_array,
                             unsetenv_others: true,
                             in: @stdin_r,
                             out: stdout.fileno,
                             err: stderr.fileno,
                             close_others: true,
                             chdir: cwd)
      end

      def stdin
        @stdin_w
      end

      def stop
        return if @exit_status

        if Aruba.platform.term_signal_supported?
          send_signal 'TERM'
          return if poll_for_exit(3)
        end

        send_signal 'KILL'
        wait
      end

      def wait
        _, status = Process.waitpid2 @pid
        @exit_status = status
      end

      def exited?
        return true if @exit_status

        pid, status = Process.waitpid2 @pid, Process::WNOHANG | Process::WUNTRACED

        if pid
          @exit_status = status
          return true
        end

        false
      end

      def poll_for_exit(exit_timeout)
        start = Time.now
        wait_until = start + exit_timeout
        loop do
          return true if exited?
          break if Time.now >= wait_until

          sleep 0.1
        end
        false
      end

      def exit_code
        @exit_status&.exitstatus
      end

      private

      def send_signal(signal)
        Process.kill signal, @pid
      end
    end

    # Spawn a process for command
    #
    # `SpawnProcess` is not meant for direct use - `SpawnProcess.new` - by
    # users. Only it's public methods are part of the public API of aruba, e.g.
    # `#stdin`, `#stdout`.
    #
    # @private
    class SpawnProcess < BasicProcess
      # Use as default launcher
      def self.match?(_mode)
        true
      end

      # Create process
      #
      # @param [String] cmd
      #   Command string
      #
      # @param [Numeric] exit_timeout
      #   The timeout until we expect the command to be finished
      #
      # @param [Numeric] io_wait_timeout
      #   The timeout until we expect the io to be finished
      #
      # @param [String] working_directory
      #   The directory where the command will be executed
      #
      # @param [Hash] environment
      #   Environment variables
      #
      # @param [Class] main_class
      #   E.g. Cli::App::Runner
      #
      # @param [String] stop_signal
      #   Name of signal to send to stop process. E.g. 'HUP'.
      #
      # @param [Numeric] startup_wait_time
      #   The amount of seconds to wait after Aruba has started a command.
      def initialize(cmd, exit_timeout, io_wait_timeout, working_directory, # rubocop:disable Metrics/ParameterLists
                     environment = Aruba.platform.environment_variables.hash_from_env,
                     main_class = nil, stop_signal = nil, startup_wait_time = 0)
        super

        @process      = nil
        @stdout_cache = nil
        @stderr_cache = nil
      end

      # Run the command
      #
      # @yield [SpawnProcess]
      #   Run code for process which was started
      #
      def start
        if started?
          error_message =
            "Command \"#{commandline}\" has already been started. " \
            'Please `#stop` the command first and `#start` it again. ' \
            'Alternatively use `#restart`.'
          raise CommandAlreadyStartedError, error_message
        end

        @started = true

        @process = ProcessRunner.new(command_string.to_a)

        @stdout_file = Tempfile.new('aruba-stdout-')
        @stderr_file = Tempfile.new('aruba-stderr-')

        @stdout_file.sync = true
        @stderr_file.sync = true

        @stdout_file.set_encoding('ASCII-8BIT')
        @stderr_file.set_encoding('ASCII-8BIT')

        @exit_status = nil

        before_run

        @process.stdout = @stdout_file
        @process.stderr = @stderr_file
        @process.cwd    = @working_directory

        @process.environment = environment

        begin
          @process.start
          sleep startup_wait_time
        rescue SystemCallError => e
          raise LaunchError, "It tried to start #{commandline}. " + e.message
        end

        after_run

        yield self if block_given?
      end

      # Access to stdin of process
      def stdin
        return if @process.exited?

        @process.io.stdin
      end

      # Access to stdout of process
      #
      # @param [Hash] opts
      #   Options
      #
      # @option [Integer] wait_for_io
      #   Wait for IO to be finished
      #
      # @return [String]
      #   The content of stdout
      def stdout(opts = {})
        return @stdout_cache if stopped?

        wait_for_io opts.fetch(:wait_for_io, io_wait_timeout) do
          @process.stdout.flush
          open(@stdout_file.path).read
        end
      end

      # Access to stderr of process
      #
      # @param [Hash] opts
      #   Options
      #
      # @option [Integer] wait_for_io
      #   Wait for IO to be finished
      #
      # @return [String]
      #   The content of stderr
      def stderr(opts = {})
        return @stderr_cache if stopped?

        wait_for_io opts.fetch(:wait_for_io, io_wait_timeout) do
          @process.stderr.flush
          open(@stderr_file.path).read
        end
      end

      def write(input)
        return if stopped?

        @process.stdin.write(input)
        @process.stdin.flush

        self
      end

      # Close io
      def close_io(name)
        return if stopped?

        @process.public_send(name.to_sym).close
      end

      # Stop command
      def stop(*)
        return @exit_status if stopped?

        @process.poll_for_exit(@exit_timeout) or @timed_out = true

        terminate
      end

      # Wait for command to finish
      def wait
        @process.wait
      end

      # Terminate command
      def terminate
        return @exit_status if stopped?

        unless @process.exited?
          if @stop_signal
            # send stop signal ...
            send_signal @stop_signal
            # ... and set the exit status
            wait
          else
            begin
              @process.stop
            rescue Errno::EPERM # This can occur on MacOS
              nil
            end
          end
        end

        @exit_status = @process.exit_code

        @stdout_cache = read_temporary_output_file @stdout_file
        @stderr_cache = read_temporary_output_file @stderr_file

        @started = false

        @exit_status
      end

      # Output pid of process
      #
      # This is the PID of the spawned process.
      def pid
        @process.pid
      end

      # Send command a signal
      #
      # @param [String] signal
      #   The signal, i.e. 'TERM'
      def send_signal(signal)
        error_message = %(Command "#{commandline}" with PID "#{pid}" has already stopped.)
        raise CommandAlreadyStoppedError, error_message if @process.exited?

        Process.kill signal, pid
      rescue Errno::ESRCH
        raise CommandAlreadyStoppedError, error_message
      end

      # Return file system stats for the given command
      #
      # @return [Aruba::Platforms::FilesystemStatus]
      #   This returns a File::Stat-object
      def filesystem_status
        Aruba.platform.filesystem_status.new(command_path)
      end

      # Content of command
      #
      # @return [String]
      #   The content of the script/command. This might be binary output as
      #   string if your command is a binary executable.
      def content
        File.read command_path
      end

      def interactive?
        true
      end

      private

      def command_string
        if command_path.nil?
          raise LaunchError,
                %(Command "#{command}" not found in PATH-variable "#{environment['PATH']}".)
        end

        Aruba.platform.command_string.new(command_path, *arguments)
      end

      def command_path
        @command_path ||=
          if Aruba.platform.builtin_shell_commands.include?(command)
            command
          else
            Aruba.platform.which(command, environment['PATH'])
          end
      end

      def wait_for_io(time_to_wait)
        sleep time_to_wait
        yield
      end

      def read_temporary_output_file(file)
        file.flush
        file.rewind
        data = file.read
        file.close

        data.force_encoding('UTF-8')
      end
    end
  end
end
