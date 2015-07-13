require 'aruba/processes/spawn_process'

module Aruba
  module Processes
    # Debug Process
    class DebugProcess < BasicProcess
      # Use only if mode is :debug
      def self.match?(mode)
        mode == :debug || (mode.is_a?(Class) && mode <= DebugProcess)
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      def run!
        # rubocop:disable  Metrics/LineLength
        fail LaunchError, %(Command "#{command}" not found in PATH-variable "#{environment['PATH']}".) unless which(command, environment['PATH'])
        # rubocop:enable  Metrics/LineLength

        if RUBY_VERSION < '1.9'
          begin
            old_env = ENV.to_hash
            ENV.update environment

            Dir.chdir @working_directory do
              @exit_status = system(@cmd) ? 0 : 1
            end
          ensure
            ENV.clear
            ENV.update old_env
          end
        elsif RUBY_VERSION < '2'
          Dir.chdir @working_directory do
            @exit_status = system(environment, @cmd) ? 0 : 1
          end
        else
          @exit_status = system(environment, @cmd, :chdir => @working_directory) ? 0 : 1
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
