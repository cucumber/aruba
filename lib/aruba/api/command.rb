require 'pathname'

require 'aruba/platform'
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

          Aruba.platform.which(program, path)
        end
      end

      # Pipe data in file
      #
      # @param [String] file_name
      #   The file which should be used to pipe in data
      def pipe_in_file(file_name)
        file_name = expand_path(file_name)

        File.open(file_name, 'r').each_line do |line|
          last_command_started.write(line)
        end
      end

      # Return all commands
      #
      # @return [Array]
      #   List of commands
      def all_commands
        aruba.command_monitor.registered_commands
      end

      # Last command started
      def last_command_started
        aruba.command_monitor.last_command_started
      end

      # Last command stopped
      def last_command_stopped
        aruba.command_monitor.last_command_stopped
      end

      # Stop all commands
      #
      # @yield [Command]
      #   If block is given use it to filter the commands which should be
      #   stoppend.
      def stop_all_commands(&block)
        cmds = if block_given?
                 all_commands.select(&block)
               else
                 all_commands
               end

        cmds.each(&:stop)

        self
      end

      # Terminate all commands
      #
      # @yield [Command]
      #   If block is given use it to filter the commands which should be
      #   terminated.
      def terminate_all_commands(&block)
        cmds = if block_given?
                 all_commands.select(&block)
               else
                 all_commands
               end

        cmds.each(&:terminate)

        self
      end

      # Find a started command
      #
      # @param [String, Command] commandline
      #   The commandline
      def find_command(commandline)
        aruba.command_monitor.find(commandline)
      end

      # Run given command and stop it if timeout is reached
      #
      # @param [String] cmd
      #   The command which should be executed
      #
      # @param [Integer] timeout
      #   If the timeout is reached the command will be killed
      #
      # @param [String] stop_signal
      #   Use signal to stop command (Private)
      #
      # @yield [SpawnProcess]
      #   Run block with process
      #
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      def run(cmd, exit_timeout = nil, io_wait_timeout = nil, stop_signal = nil, startup_wait_time = nil)
        exit_timeout ||= aruba.config.exit_timeout
        io_wait_timeout ||= aruba.config.io_wait_timeout
        stop_signal ||= aruba.config.stop_signal
        startup_wait_time ||= aruba.config.startup_wait_time

        cmd = replace_variables(cmd)

        @commands ||= []
        @commands << cmd

        environment       = aruba.environment.to_h
        working_directory = expand_path('.')

        aruba.announcer.announce(:full_environment, environment)
        aruba.announcer.announce(:timeout, 'exit', exit_timeout)
        aruba.announcer.announce(:timeout, 'io wait', io_wait_timeout)
        aruba.announcer.announce(:wait_time, 'startup wait time', startup_wait_time)

        aruba.announcer.announce(:directory, working_directory)
        aruba.announcer.announce(:command, cmd)

        cmd               = Aruba.platform.detect_ruby(cmd)

        mode = if Aruba.process
                 # rubocop:disable Metrics/LineLength
                 Aruba.platform.deprecated('The use of "Aruba.process = <process>" and "Aruba.process.main_class" is deprecated. Use "Aruba.configure { |config| config.command_launcher = :in_process|:debug|:spawn }" and "Aruba.configure { |config| config.main_class = <klass> }" instead.')
                 # rubocop:enable Metrics/LineLength
                 Aruba.process
               else
                 aruba.config.command_launcher
               end

        main_class = if Aruba.process.respond_to?(:main_class) && Aruba.process.main_class
                       # rubocop:disable Metrics/LineLength
                       Aruba.platform.deprecated('The use of "Aruba.process = <process>" and "Aruba.process.main_class" is deprecated. Use "Aruba.configure { |config| config.command_launcher = :in_process|:debug|:spawn }" and "Aruba.configure { |config| config.main_class = <klass> }" instead.')
                       # rubocop:enable Metrics/LineLength
                       Aruba.process.main_class
                     else
                       aruba.config.main_class
                     end

        aruba.command_monitor.start_command(
          cmd,
          :mode              => mode,
          :exit_timeout      => exit_timeout,
          :io_wait_timeout   => io_wait_timeout,
          :working_directory => working_directory,
          :environment       => environment,
          :main_class        => main_class,
          :stop_signal       => stop_signal,
          :startup_wait_time => startup_wait_time
        )

        command = aruba.command_monitor.find(cmd)

        if aruba.config.before? :cmd
          # rubocop:disable Metrics/LineLength
          Aruba.platform.deprecated('The use of "before"-hook" ":cmd" is deprecated. Use ":command" instead. Please be aware that this hook gets the command passed in not the cmdline itself. To get the commandline use "#cmd.commandline"')
          # rubocop:enable Metrics/LineLength
          aruba.config.before(:cmd, self, cmd)
        end

        aruba.config.before(:command, self, command)
        command.start

        aruba.announcer.announce(:stop_signal, command.pid, stop_signal) if stop_signal

        aruba.config.after(:command, self, command)

        block_given? ? yield(command) : command
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/MethodLength

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
      def run_simple(cmd, fail_on_error = true, exit_timeout = nil, io_wait_timeout = nil)
        command = run(cmd, exit_timeout, io_wait_timeout)
        command.stop

        if Aruba::VERSION < '1'
          @last_exit_status = command.exit_status
          @timed_out = command.timed_out?
        end

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
        last_command_started.write(input << "\n")
      end

      # Close stdin
      def close_input
        last_command_started.close_io(:stdin)
      end
    end
  end
end
