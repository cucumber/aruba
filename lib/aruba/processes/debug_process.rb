require 'aruba/processes/spawn_process'

module Aruba
  module Processes
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
    class DebugProcess < BasicProcess
      # @see SpawnProcess
      def initialize(cmd, _exit_timeout, _io_wait, working_directory)
        @cmd = cmd

        super
      end

      def run!
        @exit_status = system(@cmd, chdir: @working_directory) ? 0 : 1
      end

      def stdin(*); end

      def stdout(*)
        ''
      end

      def stderr(*)
        ''
      end

      def stop(_reader)
        @exit_status
      end

      def terminate(*)
        stop
      end
    end
  end
end
