# frozen_string_literal: true

require 'pathname'

require 'aruba/platform'
require 'aruba/command'

# require 'win32/file' if File::ALT_SEPARATOR

# Aruba
module Aruba
  # Api
  module Api
    # Command module
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
        cmds = if block
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
        cmds = if block
                 all_commands.select(&block)
               else
                 all_commands
               end

        cmds.each(&:terminate)

        self
      end

      # Get stdout of all processes
      #
      # @return [String]
      #   The stdout of all processes which have run before
      def all_stdout
        aruba.command_monitor.all_stdout
      end

      # Get stderr of all processes
      #
      # @return [String]
      #   The stderr of all processes which have run before
      def all_stderr
        aruba.command_monitor.all_stderr
      end

      # Get stderr and stdout of all processes
      #
      # @return [String]
      #   The stderr and stdout of all processes which have run before
      def all_output
        aruba.command_monitor.all_output
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
      # @param [Hash] opts
      #   Options
      #
      # @option opts [Numeric] exit_timeout
      #   If the timeout is reached the command will be killed
      #
      # @option opts [Numeric] io_wait_timeout
      #   Wait for IO to finish
      #
      # @option opts [Numeric] startup_wait_time
      #   Wait for a command to start
      #
      # @option opts [String] stop_signal
      #   Use signal to stop command
      #
      # @yield [SpawnProcess]
      #   Run block with process
      #
      def run_command(cmd, opts = {})
        command = prepare_command(cmd, opts)

        unless command.interactive?
          raise NotImplementedError,
                'Running interactively is not supported with this process launcher.'
        end

        start_command(command)

        block_given? ? yield(command) : command
      end

      # Run a command with aruba
      #
      # Checks for error during command execution and checks the output to detect
      # an timeout error.
      #
      # @param [String] cmd
      #   The command to be executed
      #
      # @param [Hash] opts
      #   Options for aruba
      #
      # @option opts [Boolean] :fail_on_error
      #   Should aruba fail on error?
      #
      # @option opts [Numeric] :exit_timeout
      #   Timeout for execution
      #
      # @option opts [Numeric] :io_wait_timeout
      #   Timeout for IO - STDERR, STDOUT
      #
      def run_command_and_stop(cmd, opts = {})
        fail_on_error = if opts.key?(:fail_on_error)
                          opts.delete(:fail_on_error) == true
                        else
                          true
                        end

        command = prepare_command(cmd, opts)
        start_command(command)
        command.stop

        return unless fail_on_error

        begin
          expect(command).to have_finished_in_time
          expect(command).to be_successfully_executed
        rescue ::RSpec::Expectations::ExpectationNotMetError => e
          aruba.announcer.activate(aruba.config.activate_announcer_on_command_failure)
          aruba.event_bus.notify Events::CommandStopped.new(command)
          raise e
        end
      end

      # Provide data to command via stdin
      #
      # @param [String] input
      #   The input for the command
      def type(input)
        return close_input if input == "\u0004"

        last_command_started.write("#{input}\n")
      end

      # Close stdin
      def close_input
        last_command_started.close_io(:stdin)
      end

      private

      def prepare_command(cmd, opts)
        exit_timeout      = opts[:exit_timeout] || aruba.config.exit_timeout
        io_wait_timeout   = opts[:io_wait_timeout] || aruba.config.io_wait_timeout
        stop_signal       = opts[:stop_signal] || aruba.config.stop_signal
        startup_wait_time = opts[:startup_wait_time] || aruba.config.startup_wait_time

        @commands ||= []
        @commands << cmd

        environment       = aruba.environment
        working_directory = expand_path('.')
        event_bus         = aruba.event_bus

        cmd = Aruba.platform.detect_ruby(cmd)

        mode = aruba.config.command_launcher

        main_class = aruba.config.main_class

        Command.new(
          cmd,
          mode: mode,
          exit_timeout: exit_timeout,
          io_wait_timeout: io_wait_timeout,
          working_directory: working_directory,
          environment: environment.to_hash,
          main_class: main_class,
          stop_signal: stop_signal,
          startup_wait_time: startup_wait_time,
          event_bus: event_bus
        )
      end

      def start_command(command)
        aruba.config.run_before_hook(:command, self, command)

        in_current_directory do
          command.start
        end

        stop_signal = command.stop_signal
        aruba.announcer.announce(:stop_signal, command.pid, stop_signal) if stop_signal

        aruba.config.run_after_hook(:command, self, command)
      end
    end
  end
end
