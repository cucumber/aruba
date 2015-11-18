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
      def initialize(cmd, exit_timeout, io_wait, working_directory, environment = ENV.to_hash.dup, main_class = nil, stop_signal = nil)
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
        @stdout_file = Tempfile.new("aruba-stdout-")
        @stderr_file = Tempfile.new("aruba-stderr-")

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
        return if @process.nil?

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
        return @stdout_cache if @process.nil?

        wait_for_io = opts.fetch(:wait_for_io, @io_wait)

        wait_for_io wait_for_io do
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
        return @stderr_cache if @process.nil?

        wait_for_io = opts.fetch(:wait_for_io, @io_wait)

        wait_for_io wait_for_io do
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
        return if @process.nil?

        @process.io.stdin.write(input)
        @process.io.stdin.flush

        self
      end

      def close_io(name)
        return if @process.nil?

        if RUBY_VERSION < '1.9'
          @process.io.send(name.to_sym).close
        else
          @process.io.public_send(name.to_sym).close
        end
      end

      # rubocop:disable Metrics/MethodLength
      def stop(reader)
        @stopped = true

        return @exit_status unless @process

        begin
          @process.poll_for_exit(@exit_timeout) unless @process.exited?
        rescue ChildProcess::TimeoutError
          @timed_out = true

          if @stop_signal
            Process.kill @stop_signal, pid
            # set the exit status
            @process.wait
          else
            @process.stop
          end
        end

        @exit_status = @process.exit_code
        @process   = nil

        close_and_cache_out
        close_and_cache_err

        if reader
          reader.announce :stdout, stdout
          reader.announce :stderr, stderr
        end

        @exit_status
      end
      # rubocop:enable Metrics/MethodLength

      def terminate
        return unless @process

        if @stop_signal
          Process.kill @stop_signal, pid
        else
          @process.stop
        end

        stop nil
      end

      # Output pid of process
      #
      # This is the PID of the spawned process.
      def pid
        @process.pid
      end

      private

      def wait_for_io(time_to_wait, &block)
        return if @process.nil?

        sleep time_to_wait

        yield
      end

      def read(io)
        io.rewind
        io.read
      end

      def close_and_cache_out
        @stdout_cache = read @stdout_file
        @stdout_file.close
        @stdout_file = nil
      end

      def close_and_cache_err
        @stderr_cache = read @stderr_file
        @stderr_file.close
        @stderr_file = nil
      end
    end
  end
end
