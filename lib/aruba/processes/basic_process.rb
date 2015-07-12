require 'aruba/platform'
require 'shellwords'

module Aruba
  module Processes
    class BasicProcess
      attr_reader :exit_status, :environment

      def initialize(cmd, exit_timeout, io_wait, working_directory, environment = ENV.to_hash, main_class = nil)
        @cmd               = cmd
        @working_directory = working_directory
        @environment       = environment
        @main_class        = main_class
        @exit_status       = nil
      end

      # Return command line
      def commandline
        @cmd
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

      private

      def which(program, path = environment['PATH'])
        Aruba::Platform.which(program, path)
      end

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
