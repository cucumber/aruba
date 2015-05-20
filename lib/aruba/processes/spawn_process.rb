require 'childprocess'
require 'tempfile'
require 'shellwords'
require 'aruba/errors'
require 'aruba/processes/basic_process'

module Aruba
  module Processes
    class SpawnProcess < BasicProcess
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
        @exit_timeout = exit_timeout
        @io_wait      = io_wait

        @cmd               = cmd
        @process           = nil
        @exit_code         = nil
        @output_cache      = nil
        @error_cache       = nil

        super
      end

      # Run the command
      #
      # @yield [SpawnProcess]
      #   Run code for process which was started
      def run!
        @process   = ChildProcess.build(*Shellwords.split(@cmd))
        @out       = Tempfile.new("aruba-out")
        @err       = Tempfile.new("aruba-err")
        @exit_code = nil
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

      def stdin
        @process.io.stdin
      end

      def stdout
        wait_for_io { read(@out) } || @output_cache
      end

      def stderr
        wait_for_io { read(@err) } || @error_cache
      end

      def read_stdout
        wait_for_io do
          @process.io.stdout.flush
          open(@out.path).read
        end
      end

      def stop(reader)
        return @exit_code unless @process

        @process.poll_for_exit(@exit_timeout) unless @process.exited?

        @exit_code = @process.exit_code
        @process   = nil

        close_and_cache_out
        close_and_cache_err

        if reader
          reader.stdout stdout
          reader.stderr stderr
        end

        @exit_code
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
  end
end
