require 'aruba/processes/spawn_process'

module Aruba
  module Processes
    # Debug Process
    class DebugProcess < BasicProcess
      # Use only if mode is :debug
      def self.match?(mode)
        mode == :debug || (mode.is_a?(Class) && mode <= DebugProcess)
      end

      # @deprecated
      # @private
      def run!
        Aruba::Platform.deprecated('The use of "command#run!" is deprecated. You can simply use "command#start" instead.')

        start
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      def start
        if RUBY_VERSION < '2'
          Dir.chdir @working_directory do
            with_local_env(environment) do
              @exit_status = system(command, *arguments) ? 0 : 1
            end
          end
        else
          with_local_env(environment) do
            @exit_status = system(command, *arguments, :chdir => @working_directory) ? 0 : 1
          end
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/MethodLength

      def stdin(*); end

      def stdout(*)
        ''
      end

      def stderr(*)
        ''
      end

      def stop(_reader)
        @stopped = true

        @exit_status
      end

      def terminate(*)
        stop
      end
    end
  end
end
