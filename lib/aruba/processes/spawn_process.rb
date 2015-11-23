require 'childprocess'
require 'tempfile'
require 'shellwords'

require 'aruba/errors'
require 'aruba/processes/basic_process'
require 'aruba/platform'

module Aruba
  module Processes
    class SpawnProcess < BasicProcess
      # Use as default launcher
      def self.match?(mode)
        true
      end

      # Create process
      #
      # @params [String] cmd
      #   Command string
      #
      # @params [Integer] exit_timeout
      #   The timeout until we expect the command to be finished
      #
      # @params [Integer] io_wait
      #   The timeout until we expect the io to be finished
      #
      # @params [String] working_directory
      #   The directory where the command will be executed
      def initialize(cmd, exit_timeout, io_wait, working_directory, environment = ENV.to_hash.dup, main_class = nil, stop_signal = nil, startup_wait_time = 0)
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
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      def start
        # gather fully qualified path
        cmd = Aruba.platform.which(command, environment['PATH'])

        # rubocop:disable  Metrics/LineLength
        fail LaunchError, %(Command "#{command}" not found in PATH-variable "#{environment['PATH']}".) if cmd.nil?
        # rubocop:enable  Metrics/LineLength

        cmd = Aruba.platform.command_string.new(cmd)

        @process   = ChildProcess.build(*[cmd.to_a, arguments].flatten)
        @stdout_file = Tempfile.new('aruba-stdout-')
        @stderr_file = Tempfile.new('aruba-stderr-')

        @stdout_file.sync = true
        @stderr_file.sync = true

        @exit_status = nil
        @duplex      = true

        before_run

        @process.leader    = true
        @process.io.stdout = @stdout_file
        @process.io.stderr = @stderr_file
        @process.duplex    = @duplex
        @process.cwd       = @working_directory

        @process.environment.update(environment)

        begin
          Aruba.platform.with_environment(environment) do
            @process.start
            sleep startup_wait_time
          end
        rescue ChildProcess::LaunchError => e
          raise LaunchError, "It tried to start #{cmd}. " + e.message
        end

        after_run

        yield self if block_given?
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/CyclomaticComplexity

      # Access to stdout of process
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

        wait_for_io opts.fetch(:wait_for_io, @io_wait) do
          @process.io.stdout.flush
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

        wait_for_io opts.fetch(:wait_for_io, @io_wait) do
          @process.io.stderr.flush
          open(@stderr_file.path).read
        end
      end

      def read_stdout
        # rubocop:disable Metrics/LineLength
        Aruba.platform.deprecated('The use of "#read_stdout" is deprecated. Use "#stdout" instead. To reduce the time to wait for io, pass `:wait_for_io => 0` or some suitable for your use case')
        # rubocop:enable Metrics/LineLength

        stdout(:wait_for_io => 0)
      end

      def write(input)
        return if stopped?

        @process.io.stdin.write(input)
        @process.io.stdin.flush

        self
      end

      def close_io(name)
        return if stopped?

        if RUBY_VERSION < '1.9'
          @process.io.send(name.to_sym).close
        else
          @process.io.public_send(name.to_sym).close
        end
      end

      # rubocop:disable Metrics/MethodLength
      def stop(reader)
        return @exit_status if stopped?

        begin
          @process.poll_for_exit(@exit_timeout)
        rescue ChildProcess::TimeoutError
          @timed_out = true
        end

        terminate

        if reader
          reader.announce :stdout, @stdout_cache
          reader.announce :stderr, @stderr_cache
        end

        @exit_status
      end
      # rubocop:enable Metrics/MethodLength

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
            @process.stop
          end
        end

        @exit_status  = @process.exit_code

        @stdout_cache = read_temporary_output_file @stdout_file
        @stderr_cache = read_temporary_output_file @stderr_file

        # @stdout_file = nil
        # @stderr_file = nil

        @stopped      = true

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
        Process.kill signal, pid
      end

      private

      def wait_for_io(time_to_wait, &block)
        sleep time_to_wait.to_i
        block.call
      end

      def read_temporary_output_file(file)
        file.flush
        file.rewind
        data = file.read
        file.close

        data
      end
    end
  end
end
