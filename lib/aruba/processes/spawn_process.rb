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
      def initialize(cmd, exit_timeout, io_wait, working_directory, environment = ENV.to_hash.dup, main_class = nil)
        super

        @exit_timeout = exit_timeout
        @io_wait      = io_wait
        @process      = nil
        @output_cache = nil
        @error_cache  = nil
      end

      # @deprecated
      # @private
      def run!
        Aruba::Platform.deprecated('The use of "command#run!" is deprecated. You can simply use "command#start" instead.')

        start
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
        cmd = which(command)
        # rubocop:disable  Metrics/LineLength
        fail LaunchError, %(Command "#{command}" not found in PATH-variable "#{environment['PATH']}".) if cmd.nil?
        # rubocop:enable  Metrics/LineLength

        cmd = Aruba.platform.command_string.new(cmd)

        @process   = ChildProcess.build(*[cmd.to_a, arguments].flatten)
        @out       = Tempfile.new("aruba-out")
        @err       = Tempfile.new("aruba-err")
        @exit_status = nil
        @duplex    = true

        before_run

        @process.io.stdout = @out
        @process.io.stderr = @err
        @process.duplex    = @duplex
        @process.cwd       = @working_directory

        @process.environment.update(environment)

        begin
          @process.start
        rescue ChildProcess::LaunchError => e
          raise LaunchError, "It tried to start #{cmd}. " + e.message
        end

        after_run

        yield self if block_given?
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/CyclomaticComplexity

      def stdin
        return if @process.nil?

        @process.io.stdin
      end

      def stdout(opts = {})
        return @output_cache if @process.nil?

        wait_for_io = opts.fetch(:wait_for_io, @io_wait)

        wait_for_io wait_for_io do
          @process.io.stdout.flush
          open(@err).read
        end
      end

      def stderr(opts = {})
        return @error_cache if @process.nil?

        wait_for_io = opts.fetch(:wait_for_io, @io_wait)

        wait_for_io wait_for_io do
          @process.io.stderr.flush
          open(@err).read
        end
      end

      def read_stdout
        # rubocop:disable Metrics/LineLength
        Aruba::Platform.deprecated('The use of "#read_stdout" is deprecated. Use "#stdout" instead. To reduce the time to wait for io, pass `:wait_for_io => 0` or some suitable for your use case')
        # rubocop:enable Metrics/LineLength

        stdout
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

      def stop(reader)
        @stopped = true

        return @exit_status unless @process

        begin
          @process.poll_for_exit(@exit_timeout) unless @process.exited?
        rescue ChildProcess::TimeoutError
          @timed_out = true
          @process.stop
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

      def terminate
        return unless @process

        @process.stop
        stop nil
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
        @output_cache = read @out
        @out.close
        @out = nil
      end

      def close_and_cache_err
        @error_cache = read @err
        @err.close
        @err = nil
      end
    end
  end
end
