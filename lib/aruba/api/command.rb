require 'pathname'

require 'aruba/platform'
require 'aruba/process_monitor'
require 'aruba/command'

# require 'win32/file' if File::ALT_SEPARATOR

module Aruba
  class << self
    # @deprecated
    attr_accessor :process
  end

  # @deprecated
  # self.process = Aruba::Processes::SpawnProcess
end

module Aruba
  module Api
    module Commands
      # Resolve path for command using the PATH-environment variable
      #
      # @param [#to_s] program
      #   The name of the program which should be resolved
      #
      # @param [String] path
      #   The PATH, a string concatenated with ":", e.g. /usr/bin/:/bin on a
      #   UNIX-system
      def which(program, path = nil)
        with_environment do
          # ENV is set within this block
          path = ENV['PATH'] if path.nil?

          Aruba::Platform.which(program, path)
        end
      end

      # Pipe data in file
      #
      # @param [String] file_name
      #   The file which should be used to pipe in data
      def pipe_in_file(file_name)
        file_name = expand_path(file_name)

        File.open(file_name, 'r').each_line do |line|
          last_command.write(line)
        end
      end

      # Fetch output (stdout, stderr) from command
      #
      # @param [String] cmd
      #   The command
      def output_from(cmd)
        process_monitor.output_from(cmd)
      end

      # Fetch stdout from command
      #
      # @param [String] cmd
      #   The command
      def stdout_from(cmd)
        process_monitor.stdout_from(cmd)
      end

      # Fetch stderr from command
      #
      # @param [String] cmd
      #   The command
      def stderr_from(cmd)
        process_monitor.stderr_from(cmd)
      end

      # Get stdout of all processes
      #
      # @return [String]
      #   The stdout of all process which have run before
      def all_stdout
        process_monitor.all_stdout
      end

      # Get stderr of all processes
      #
      # @return [String]
      #   The stderr of all process which have run before
      def all_stderr
        process_monitor.all_stderr
      end

      # Get stderr and stdout of all processes
      #
      # @return [String]
      #   The stderr and stdout of all process which have run before
      def all_output
        process_monitor.all_output
      end

      # Full compare arg1 and arg2
      #
      # @return [TrueClass, FalseClass]
      #   If arg1 is exactly the same as arg2 return true, otherwise false
      def assert_exact_output(expected, actual)
        actual.force_encoding(expected.encoding) if RUBY_VERSION >= "1.9"
        expect(Aruba::Platform.unescape(actual, aruba.config.keep_ansi)).to eq Aruba::Platform.unescape(expected, aruba.config.keep_ansi)
      end

      # Partial compare arg1 and arg2
      #
      # @return [TrueClass, FalseClass]
      #   If arg2 contains arg1 return true, otherwise false
      def assert_partial_output(expected, actual)
        actual.force_encoding(expected.encoding) if RUBY_VERSION >= "1.9"
        expect(Aruba::Platform.unescape(actual, aruba.config.keep_ansi)).to include(Aruba::Platform.unescape(expected, aruba.config.keep_ansi))
      end

      # Regex Compare arg1 and arg2
      #
      # @return [TrueClass, FalseClass]
      #   If arg2 matches arg1 return true, otherwise false
      def assert_matching_output(expected, actual)
        actual.force_encoding(expected.encoding) if RUBY_VERSION >= "1.9"
        expect(Aruba::Platform.unescape(actual, aruba.config.keep_ansi)).to match(/#{Aruba::Platform.unescape(expected, aruba.config.keep_ansi)}/m)
      end

      # Negative regex compare arg1 and arg2
      #
      # @return [TrueClass, FalseClass]
      #   If arg2 does not match arg1 return true, otherwise false
      def assert_not_matching_output(expected, actual)
        actual.force_encoding(expected.encoding) if RUBY_VERSION >= "1.9"
        expect(Aruba::Platform.unescape(actual, aruba.config.keep_ansi)).not_to match(/#{Aruba::Platform.unescape(expected, aruba.config.keep_ansi)}/m)
      end

      # Negative partial compare arg1 and arg2
      #
      # @return [TrueClass, FalseClass]
      #   If arg2 does not match/include arg1 return true, otherwise false
      def assert_no_partial_output(unexpected, actual)
        actual.force_encoding(unexpected.encoding) if RUBY_VERSION >= "1.9"
        if Regexp === unexpected
          expect(Aruba::Platform.unescape(actual, aruba.config.keep_ansi)).not_to match unexpected
        else
          expect(Aruba::Platform.unescape(actual, aruba.config.keep_ansi)).not_to include(unexpected)
        end
      end

      # Partial compare output of interactive command and arg1
      #
      # @return [TrueClass, FalseClass]
      #   If output of interactive command includes arg1 return true, otherwise false
      def assert_partial_output_interactive(expected)
        Aruba::Platform.unescape(last_command.stdout, aruba.config.keep_ansi).include?(Aruba::Platform.unescape(expected, aruba.config.keep_ansi)) ? true : false
      end

      # Check if command succeeded and if arg1 is included in output
      #
      # @return [TrueClass, FalseClass]
      #   If exit status is 0 and arg1 is included in output return true, otherwise false
      def assert_passing_with(expected)
        assert_success(true)
        assert_partial_output(expected, all_output)
      end

      # Check if command failed and if arg1 is included in output
      #
      # @return [TrueClass, FalseClass]
      #   If exit status is not equal 0 and arg1 is included in output return true, otherwise false
      def assert_failing_with(expected)
        assert_success(false)
        assert_partial_output(expected, all_output)
      end

      # Check exit status of process
      #
      # @return [TrueClass, FalseClass]
      #   If arg1 is true, return true if command was successful
      #   If arg1 is false, return true if command failed
      def assert_success(success)
        if success
          expect(last_command).to be_successfully_executed
        else
          expect(last_command).not_to be_successfully_executed
        end
      end

      # @private
      def assert_exit_status(status)
        expect(last_command).to have_exit_status(status)
      end

      # @private
      def assert_not_exit_status(status)
        expect(last_exit_status).not_to eq(status),
          append_output_to("Exit status was #{last_exit_status} which was not expected.")
      end

      # @private
      def append_output_to(message)
        "#{message} Output:\n\n#{all_output}\n"
      end

      def process_monitor
        return @process_monitor if defined? @process_monitor

        @process_monitor = ProcessMonitor.new(announcer)

        @process_monitor
      end

      # @private
      def processes
        process_monitor.send(:processes)
      end

      # @private
      def stop_processes!
        process_monitor.stop_processes!
      end

      # Terminate all running processes
      def terminate_processes!
        process_monitor.terminate_processes!
      end

      # @private
      def last_command
        processes.last[1]
      end

      # @private
      def register_process(*args)
        process_monitor.register_process(*args)
      end

      # @private
      def get_process(wanted)
        process_monitor.get_process(wanted)
      end

      # Run given command and stop it if timeout is reached
      #
      # @param [String] cmd
      #   The command which should be executed
      #
      # @param [Integer] timeout
      #   If the timeout is reached the command will be killed
      #
      # @yield [SpawnProcess]
      #   Run block with process
      #
      # rubocop:disable Metrics/MethodLength
      def run(cmd, timeout = nil)
        timeout ||= exit_timeout
        @commands ||= []
        @commands << cmd

        cmd = Aruba::Platform.detect_ruby(cmd)

        announcer.announce(:directory, Dir.pwd)
        announcer.announce(:command, cmd)
        announcer.announce(:timeout, 'exit', aruba.config.exit_timeout)
        announcer.announce(:full_environment, aruba.environment.to_h)

        mode = if Aruba.process
                 # rubocop:disable Metrics/LineLength
                 Aruba::Platform.deprecated('The use of "Aruba.process = <process>" and "Aruba.process.main_class" is deprecated. Use "Aruba.configure { |config| config.command_launcher = :in_process|:debug|:spawn }" and "Aruba.configure { |config| config.main_class = <klass> }" instead.')
                 # rubocop:enable Metrics/LineLength
                 Aruba.process
               else
                 aruba.config.command_launcher
               end

        main_class = if Aruba.process.respond_to?(:main_class) && Aruba.process.main_class
                       # rubocop:disable Metrics/LineLength
                       Aruba::Platform.deprecated('The use of "Aruba.process = <process>" and "Aruba.process.main_class" is deprecated. Use "Aruba.configure { |config| config.command_launcher = :in_process|:debug|:spawn }" and "Aruba.configure { |config| config.main_class = <klass> }" instead.')
                       # rubocop:enable Metrics/LineLength
                       Aruba.process.main_class
                     else
                       aruba.config.main_class
                     end
        command = Command.new(
          cmd,
          :mode              => mode,
          :exit_timeout      => timeout,
          :io_wait_timeout   => io_wait,
          :working_directory => expand_path('.'),
          :environment       => aruba.environment.to_h,
          :main_class        => main_class
        )

        if aruba.config.before? :cmd
          # rubocop:disable Metrics/LineLength
          Aruba::Platform.deprecated('The use of "before"-hook" ":cmd" is deprecated. Use ":command" instead. Please be aware that this hook gets the command passed in not the cmdline itself. To get the commandline use "#cmd.commandline"')
          # rubocop:enable Metrics/LineLength
          aruba.config.before(:cmd, self, cmd)
        end

        aruba.config.before(:command, self, command)

        process_monitor.register_process(cmd, command)
        command.run!

        aruba.config.after(:command, self, command)

        block_given? ? yield(command) : command
      end
      # rubocop:enable Metrics/MethodLength

      # Default exit timeout for running commands with aruba
      #
      # Overwrite this method if you want a different timeout or set
      # `@aruba_timeout_seconds`.
      def exit_timeout
        aruba.config.exit_timeout
      end

      # Default io wait timeout
      #
      # Overwrite this method if you want a different timeout or set
      # `@aruba_io_wait_seconds
      def io_wait
        aruba.config.io_wait_timeout
      end

      # The root directory of aruba
      def root_directory
        aruba.config.root_directory
      end

      # Run a command with aruba
      #
      # Checks for error during command execution and checks the output to detect
      # an timeout error.
      #
      # @param [String] cmd
      #   The command to be executed
      #
      # @param [TrueClass,FalseClass] fail_on_error
      #   Should aruba fail on error?
      #
      # @param [Integer] timeout
      #   Timeout for execution
      def run_simple(cmd, fail_on_error = true, timeout = nil)
        command = run(cmd, timeout)
        @last_exit_status = process_monitor.stop_process(command)

        @timed_out = command.timed_out?

        if fail_on_error
          expect(command).to have_finished_in_time
          expect(command).to be_successfully_executed
        end
      end

      # Provide data to command via stdin
      #
      # @param [String] input
      #   The input for the command
      def type(input)
        return close_input if "" == input
        last_command.write(input << "\n")
      end

      # Close stdin
      def close_input
        last_command.close_io(:stdin)
      end

      # Only processes
      def only_processes
        process_monitor.only_processes
      end

      # TODO: move some more methods under here!

      private

      def last_exit_status
        process_monitor.last_exit_status
      end

      def stop_process(process)
        @last_exit_status = process_monitor.stop_process(process)
      end

      def terminate_process(process)
        process_monitor.terminate_process(process)
      end
    end
  end
end
