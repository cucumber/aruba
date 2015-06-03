require 'childprocess'
require 'tempfile'
require 'shellwords'
require 'aruba/errors'
require 'aruba/processes/basic_process'

module Aruba
  module Processes
    # rubocop:disable Metrics/ClassLength
    class SpawnProcess < BasicProcess
      attr_reader :exit_status

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
      def initialize(cmd, exit_timeout, io_wait, working_directory)

        @exit_timeout  = exit_timeout
        @io_wait       = io_wait
        @cmd           = cmd
        @process       = nil
        @exit_status   = nil
        @output_cache  = nil
        @error_cache   = nil

        super
      end

      # Return command line
      def commandline
        @cmd
      end

      # Run the command
      #
      # @yield [SpawnProcess]
      #   Run code for process which was started
      # rubocop:disable Metrics/MethodLength
      def run!
        @process   = ChildProcess.build(*Shellwords.split(@cmd))
        @out       = Tempfile.new("aruba-out")
        @err       = Tempfile.new("aruba-err")
        @exit_status = nil
        @duplex    = true

        before_run

        @process.io.stdout = @out
        @process.io.stderr = @err
        @process.duplex    = @duplex
        @process.cwd       = @working_directory

        begin
          @process.start
        rescue ChildProcess::LaunchError => e
          raise LaunchError, e.message
        end

        after_run

        yield self if block_given?
      end
      # rubocop:enable Metrics/MethodLength

      def stdin
        @process.io.stdin
      end

      def stdout
        wait_for_io do
          @process.io.stdout.flush
          read(@out)
        end || @output_cache
      end

      def stderr
        wait_for_io do
          @process.io.stderr.flush
          read(@err)
        end || @error_cache
      end

      def read_stdout
        warn('The use of "#read_stdout" is deprecated. Use "#stdout" instead.')
        stdout
      end

      def write(input)
        @process.io.stdin.write(input)
        @process.io.stdin.flush
      end

      def close_io(name)
        @process.io.public_send(name.to_sym).close
      end

      def stop(reader)
        @stopped = true

        return @exit_status unless @process

        @process.poll_for_exit(@exit_timeout) unless @process.exited?

        @exit_status = @process.exit_code
        @process   = nil

        close_and_cache_out
        close_and_cache_err

        if reader
          reader.stdout stdout
          reader.stderr stderr
        end

        @exit_status
      end

      def terminate
        return unless @process

        @process.stop
        stop nil
      end

      private

      def wait_for_io(&block)
        return unless @process

        sleep @io_wait
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
    # rubocop:enable Metrics/ClassLength
  end
end
