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
      #
      # @return [String]
      #   The command line of process
      def commandline
        @cmd
      end

      # Run the command
      #
      # @yield [SpawnProcess]
      #   Run code for process which was started
      # rubocop:disable Metrics/MethodLength
      def start
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

        self
      end
      alias_method :run!, :start
      # rubocop:enable Metrics/MethodLength

      # Make stdin avaiable
      def stdin
        @process.io.stdin
      end

      # Return stdout
      #
      # @param [TrueClass, FalseClass] wait
      #   Wait(true), Do not wait(false) for io before output it
      #
      # @return [String]
      #   The string of stdout
      def stdout(wait: true)
        return @output_cache if @output_cache # output channel was closed before due to command stop

        if wait
          wait_for_io do
            @process.io.stdout.flush
            read(@out)
          end
        else
          @process.io.stdout.flush
          read(@out)
        end
      end

      # Return stderr
      #
      # @param [TrueClass, FalseClass] wait
      #   Wait(true), Do not wait(false) for io before output it
      #
      # @return [String]
      #   The string of stderr
      def stderr(wait: true)
        return @error_cache if @error_cache # output channel was closed before due to command stop

        if wait
          wait_for_io do
            @process.io.stderr.flush
            read(@err)
          end
        else
          @process.io.stderr.flush
          read(@err)
        end
      end

      # @private
      # @deprecated
      def read_stdout
        warn('The use of "#read_stdout" is deprecated. Use "#stdout" instead.')
        stdout
      end

      # Write to stdin
      #
      # @param [String] input
      #   The input string
      def write(input)
        @process.io.stdin.write(input)
        @process.io.stdin.flush

        self
      end

      # Close io of process
      #
      # @param [String, Symbol] name
      #   The name of the io
      def close_io(name)
        @process.io.public_send(name.to_sym).close

        self
      end

      # Stop process
      def stop
        @stopped = true

        return @exit_status unless @process

        @process.poll_for_exit(@exit_timeout) unless @process.exited?

        @exit_status = @process.exit_code
        @process   = nil

        close_and_cache_out
        close_and_cache_err

        self
      end

      # Terminate process
      #
      # This does not wait for process until @exit_timeout is passed but stop
      # it at once.
      def terminate
        return unless @process

        @process.stop
        stop

        self
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
        @output_cache = read(@out)
        @out.close
        @out = nil

        self
      end

      def close_and_cache_err
        @error_cache = read(@err)
        @err.close
        @err = nil

        self
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
