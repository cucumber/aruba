require 'aruba/errors'

# Aruba
module Aruba
  # The command monitor is part of the private API of Aruba.
  #
  # @private
  class CommandMonitor
    private

    attr_reader :announcer

    public

    attr_reader :registered_commands, :last_command_started

    class DefaultLastCommandStopped
      def nil?
        true
      end

      def method_missing(*)
        fail NoCommandHasBeenStoppedError, 'No last command stopped available'
      end
    end

    class DefaultLastCommandStarted
      def nil?
        true
      end

      def method_missing(*)
        fail NoCommandHasBeenStartedError, 'No last command started available'
      end
    end

    # rubocop:disable Metrics/MethodLength
    def initialize(opts = {})
      @registered_commands = []
      @announcer = opts.fetch(:announcer)

      @last_command_stopped = DefaultLastCommandStopped.new
      @last_command_started = DefaultLastCommandStarted.new

    rescue KeyError => e
      raise ArgumentError, e.message
    end

    if Aruba::VERSION < '1'
      # Return the last command stopped
      def last_command_stopped
        return @last_command_stopped unless @last_command_stopped.nil?

        registered_commands.each(&:stop)

        @last_command_stopped
      end
    else
      attr_reader :last_command_stopped
    end

    # Set last command started
    #
    # @param [String] cmd
    #   The commandline of the command
    def last_command_started=(cmd)
      @last_command_started = find(cmd)
    end

    # Set last command started
    #
    # @param [String] cmd
    #   The commandline of the command
    def last_command_stopped=(cmd)
      @last_command_stopped = find(cmd)
    end

    # Find command
    #
    # @yield [Command]
    #   This yields the found command
    def find(cmd)
      cmd = cmd.commandline if cmd.respond_to? :commandline
      command = registered_commands.reverse.find { |c| c.commandline == cmd }

      fail CommandNotFoundError, "No command named '#{cmd}' has been started" if command.nil?

      command
    end

    # Clear list of known commands
    def clear
      registered_commands.each(&:terminate)
      registered_commands.clear

      self
    end

    # @deprecated
    # Fetch output (stdout, stderr) from command
    #
    # @param [String] cmd
    #   The command
    def output_from(cmd)
      cmd = Utils.detect_ruby(cmd)
      find(cmd).output
    end

    # @deprecated
    # Fetch stdout from command
    #
    # @param [String] cmd
    #   The command
    def stdout_from(cmd)
      cmd = Utils.detect_ruby(cmd)
      find(cmd).stdout
    end

    # @deprecated
    # Fetch stderr from command
    #
    # @param [String] cmd
    #   The command
    def stderr_from(cmd)
      cmd = Utils.detect_ruby(cmd)
      find(cmd).stderr
    end

    # @deprecated
    # Get stdout of all commands
    #
    # @return [String]
    #   The stdout of all command which have run before
    def all_stdout
      registered_commands.each(&:stop)

      if RUBY_VERSION < '1.9.3'
        # rubocop:disable Style/EachWithObject
        registered_commands.inject("") { |a, e| a << e.stdout; a }
        # rubocop:enable Style/EachWithObject
      else
        registered_commands.each_with_object("") { |e, a| a << e.stdout }
      end
    end

    # @deprecated
    # Get stderr of all commands
    #
    # @return [String]
    #   The stderr of all command which have run before
    def all_stderr
      registered_commands.each(&:stop)

      if RUBY_VERSION < '1.9.3'
        # rubocop:disable Style/EachWithObject
        registered_commands.inject("") { |a, e| a << e.stderr; a }
        # rubocop:enable Style/EachWithObject
      else
        registered_commands.each_with_object("") { |e, a| a << e.stderr }
      end
    end

    # @deprecated
    # Get stderr and stdout of all commands
    #
    # @return [String]
    #   The stderr and stdout of all command which have run before
    def all_output
      all_stdout << all_stderr
    end

    # @deprecated
    def last_exit_status
      Aruba.platform.deprecated('The use of "#last_exit_status" is deprecated. Use "last_command_(started|stopped).exit_status" instead')

      return @last_exit_status if @last_exit_status
      registered_commands.each(&:stop)
      @last_exit_status
    end

    # @deprecated
    def stop_process(process)
      @last_command_stopped = process
      @last_exit_status     = process.stop(announcer)
    end

    # @deprecated
    def terminate_process!(process)
      process.terminate
    end

    # @deprecated
    def stop_processes!
      Aruba.platform.deprecated('The use of "#stop_processes!" is deprecated.')

      registered_commands.each(&:stop)
    end

    # @deprecated
    # Terminate all running processes
    def terminate_processes
      Aruba.platform.deprecated('The use of "#terminate_processes" is deprecated.')

      registered_commands.each(&:terminate)
    end

    # @deprecated
    def only_processes
      Aruba.platform.deprecated('The use of "#only_processes" is deprecated.')

      registered_commands
    end

    # @deprecated
    def get_process(wanted)
      command = find(wanted)
      raise ArgumentError.new("No process named '#{wanted}' has been started") unless command

      command
    end

    # Register command to monitor
    def register_command(cmd)
      registered_commands << cmd

      self
    end
  end
end
