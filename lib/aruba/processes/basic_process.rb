require 'aruba/platform'
require 'shellwords'

# Aruba
module Aruba
  # Processes
  module Processes
    # Basic Process
    #
    # `BasicProcess` is not meant for direct use - `BasicProcess.new` - by users.
    #
    # @private
    class BasicProcess
      attr_reader :exit_status, :environment, :working_directory, :main_class, :io_wait_timeout, :exit_timeout, :startup_wait_time

      def initialize(cmd, exit_timeout, io_wait_timeout, working_directory, environment = ENV.to_hash.dup, main_class = nil, stop_signal = nil, startup_wait_time = 0)
        @cmd               = cmd
        @working_directory = working_directory
        @environment       = environment
        @main_class        = main_class
        @exit_status       = nil
        @stop_signal       = stop_signal
        @startup_wait_time = startup_wait_time

        @exit_timeout    = exit_timeout
        @io_wait_timeout = io_wait_timeout

        @started         = false
      end

      # Return command line
      def commandline
        @cmd
      end

      # Output pid of process
      def pid
        'No implemented'
      end

      # Output stderr and stdout
      def output(opts = {})
        stdout(opts) + stderr(opts)
      end

      def write(*)
        NotImplementedError
      end

      def stdin(*)
        NotImplementedError
      end

      def stdout(*)
        NotImplementedError
      end

      def stderr(*)
        NotImplementedError
      end

      def close_io(*)
        NotImplementedError
      end

      def send_signal(*)
        NotImplementedError
      end

      def filesystem_status
        NotImplementedError
      end

      def content
        NotImplementedError
      end

      def wait
        NotImplementedError
      end

      # Restart a command
      def restart
        stop
        start
      end

      # Was process already stopped
      def stopped?
        @started == false
      end

      # Was process already started
      def started?
        @started == true
      end

      # Does the process failed to stop in time
      def timed_out?
        @timed_out == true
      end

      # @deprecated
      # @private
      def run!
        Aruba.platform.deprecated('The use of "command#run!" is deprecated. You can simply use "command#start" instead.')

        start
      end

      # Hook which is run before command is run
      def before_run; end

      # Hook which is run after command is run
      def after_run; end

      def inspect
        out = stdout(:wait_for_io => 0) + stderr(:wait_for_io => 0)

        out = if out.length > 76
                out[0, 75] + ' ...'
              else
                out
              end

        format '#<%s:%s commandline="%s": output="%s">', self.class, self.object_id, commandline, out
      end
      alias to_s inspect

      private

      def command
        Shellwords.split(commandline).first
      end

      def arguments
        return Shellwords.split(commandline)[1..-1] if Shellwords.split(commandline).size > 1

        []
      end
    end
  end
end
