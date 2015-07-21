require 'aruba/platform'
require 'shellwords'

module Aruba
  module Processes
    class BasicProcess
      attr_reader :exit_status, :environment

      def initialize(cmd, exit_timeout, io_wait, working_directory, environment = ENV.to_hash.dup, main_class = nil)
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

      # Was process already stopped
      def stopped?
        @stopped == true
      end

      # Does the process failed to stop in time
      def timed_out?
        @timed_out == true
      end

      # @deprecated
      # @private
      def run!
        Aruba::Platform.deprecated('The use of "command#run!" is deprecated. You can simply use "command#start" instead.')

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
      alias_method :to_s, :inspect

      private

      def with_local_env(e, &block)
        old_env = ENV.to_hash
        ENV.update e

        block.call
      ensure
        ENV.clear
        ENV.update old_env
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
