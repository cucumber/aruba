require 'pathname'

require 'aruba/platform'
require 'aruba/command'

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
      # @param [Hash] opts
      #   Options
      #
      # @option [Integer] exit_timeout
      #   If the timeout is reached the command will be killed
      #
      # @option [Integer] io_wait_timeout
      #   Wait for IO to finish
      #
      # @option [Integer] startup_wait_time
      #   Wait for a command to start
      #
      # @option [String] stop_signal
      #   Use signal to stop command
      #
      # @yield [SpawnProcess]
      #   Run block with process
      #
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      def run(*args)
        fail ArgumentError, 'Please pass at least a command as first argument.' if args.size < 1

        cmd = args.shift

        if args.last.is_a? Hash
          opts = args.pop

          exit_timeout      = opts[:exit_timeout].nil? ? aruba.config.exit_timeout : opts[:exit_timeout]
          io_wait_timeout   = opts[:io_wait_timeout].nil? ? aruba.config.io_wait_timeout : opts[:io_wait_timeout]
          stop_signal       = opts[:stop_signal].nil? ? aruba.config.stop_signal : opts[:stop_signal]
          startup_wait_time = opts[:startup_wait_time].nil? ? aruba.config.startup_wait_time : opts[:startup_wait_time]
        else
          raise NotImplementedError, "Commands can only be passed as string for now (unlike, e.g. Kernel.system())" if args.size > 1

          exit_timeout      = args[0].nil? ? aruba.config.exit_timeout : args[0]
          io_wait_timeout   = args[1].nil? ? aruba.config.io_wait_timeout : args[1]
          stop_signal       = args[2].nil? ? aruba.config.stop_signal : args[2]
          startup_wait_time = args[3].nil? ? aruba.config.startup_wait_time : args[3]
        end

        cmd = replace_variables(cmd)

        @commands ||= []
        @commands << cmd

        environment       = aruba.environment
        working_directory = expand_path('.')
        event_bus         = aruba.event_bus

        cmd = Aruba.platform.detect_ruby(cmd)

        mode = aruba.config.command_launcher

        main_class = aruba.config.main_class

        command = Command.new(
          cmd,
          :mode              => mode,
          :exit_timeout      => exit_timeout,
          :io_wait_timeout   => io_wait_timeout,
          :working_directory => working_directory,
          :environment       => environment.to_hash,
          :main_class        => main_class,
          :stop_signal       => stop_signal,
          :startup_wait_time => startup_wait_time,
          :event_bus         => event_bus
        )

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
      # @param [Hash] options
      #   Options for aruba
      #
      # @option [TrueClass,FalseClass] fail_on_error
      #   Should aruba fail on error?
      #
      # @option [Integer] exit_timeout
      #   Timeout for execution
      #
      # @option [Integer] io_wait_timeout
      #   Timeout for IO - STDERR, STDOUT
      #
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength
      def run_simple(*args)
        fail ArgumentError, 'Please pass at least a command as first argument.' if args.size < 1

        cmd = args.shift

        if args.last.is_a? Hash
          opts = args.pop
          fail_on_error = opts.delete(:fail_on_error) == true ? true : false
        else
          raise NotImplementedError, "Commands can only be passed as string for now (unlike, e.g. Kernel.system())" if args.size > 1

          fail_on_error = args[0] == false ? false : true

          opts = {
            :exit_timeout      => (args[1] || aruba.config.exit_timeout),
            :io_wait_timeout   => (args[2] || aruba.config.io_wait_timeout),
            :stop_signal       => (args[3] || aruba.config.stop_signal),
            :startup_wait_time => (args[4] || aruba.config.startup_wait_time)
          }
        end

        # Prevent duplicate announce
        activated = [:stdout, :stderr].select do |channel|
          aruba.announcer.activated?(channel)
        end
        aruba.announcer.deactivate(*activated)

        command = run(cmd, opts)
        command.stop

        # Reenable for stop_all_commands
        aruba.announcer.activate(*activated)

        if Aruba::VERSION < '1'
          @last_exit_status = command.exit_status
          @timed_out = command.timed_out?
        end

        if fail_on_error
          begin
            expect(command).to have_finished_in_time
            expect(command).to be_successfully_executed
          rescue RSpec::Expectations::ExpectationNotMetError => e
            aruba.announcer.activate(aruba.config.activate_announcer_on_command_failure)
            raise e
          end
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/MethodLength

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
