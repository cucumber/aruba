require 'aruba/processes/spawn_process'

# Aruba
module Aruba
  # Processes
  module Processes
    # Run your command in `systemd()` to make debugging it easier
    #
    # `DebugProcess` is not meant for direct use - `InProcess.new` - by
    # users. Only it's public methods are part of the public API of aruba, e.g.
    # `#stdin`, `#stdout`.
    #
    # @private
    class DebugProcess < BasicProcess
      # Use only if mode is :debug
      def self.match?(mode)
        mode == :debug || (mode.is_a?(Class) && mode <= DebugProcess)
      end

      def start
        Dir.chdir @working_directory do
          Aruba.platform.with_environment(environment) do
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
        'This is the debug launcher on STDOUT. If this output is unexpected, please check your setup.'
      end

      # Return stderr
      #
      # @return [String]
      #   A predefined string to make users aware they are using the DebugProcess
      def stderr(*)
        'This is the debug launcher on STDERR. If this output is unexpected, please check your setup.'
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
    end
  end
end
