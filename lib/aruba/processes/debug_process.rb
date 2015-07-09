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
