# frozen_string_literal: true

require 'aruba/processes/spawn_process'

# Aruba
module Aruba
  # Processes
  module Processes
    # Run your command in `system()` to make debugging it easier. This will
    # make the process use the default input and output streams so the
    # developer can interact with it directly. This means that part of Aruba's
    # functionality is disabled. I.e., checks for output, and passing input
    # programmatically will not work.
    #
    # `DebugProcess` is not meant for direct use - `DebugProcess.new` - by
    # users. Only its public methods are part of the public API of aruba, e.g.
    # `#stdin`, `#stdout`.
    #
    # @private
    class DebugProcess < BasicProcess
      # Use only if mode is :debug
      def self.match?(mode)
        mode == :debug || (mode.is_a?(Class) && mode <= DebugProcess)
      end

      def start
        @started = true
        Dir.chdir @working_directory do
          Aruba.platform.with_replaced_environment(environment) do
            @exit_status = system(command, *arguments) ? 0 : 1
          end
        end
      end

      # Return stdin
      #
      # @return [NilClass]
      #   Nothing
      def stdin(*); end

      # Return stdout
      #
      # @return [String]
      #   A predefined string to make users aware they are using the DebugProcess
      def stdout(*)
        'This is the debug launcher on STDOUT. ' \
          'If this output is unexpected, please check your setup.'
      end

      # Return stderr
      #
      # @return [String]
      #   A predefined string to make users aware they are using the DebugProcess
      def stderr(*)
        'This is the debug launcher on STDERR. ' \
          'If this output is unexpected, please check your setup.'
      end

      # Write to nothing
      def write(*); end

      # Close nothing
      def close_io(*); end

      # Stop process
      def stop(*)
        @started = false

        @exit_status
      end

      # Terminate process
      def terminate(*)
        stop
      end

      def interactive?
        true
      end
    end
  end
end
