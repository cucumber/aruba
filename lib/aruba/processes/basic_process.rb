module Aruba
  module Processes
    class BasicProcess
      attr_accessor :environment

      def initialize(cmd, exit_timeout, io_wait, working_directory)
        @working_directory = working_directory
        @environment       = ENV.to_hash
      end

      # Output stderr and stdout
      def output
        stdout + stderr
      end

      # Was process already stopped
      def stopped?
        @stopped == true
      end

      # Does the process failed to stop in time
      def timed_out?
        @timed_out == true
      end

      # Hook which is run before command is run
      def before_run; end

      # Hook which is run after command is run
      def after_run; end
    end
  end
end
