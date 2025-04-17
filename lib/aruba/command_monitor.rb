# frozen_string_literal: true

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

    attr_reader :registered_commands, :last_command_started, :last_command_stopped

    class DefaultLastCommandStopped
      def empty?
        true
      end

      def method_missing(*)
        raise NoCommandHasBeenStoppedError, 'No last command stopped available'
      end

      def respond_to_missing?(*)
        true
      end
    end

    class DefaultLastCommandStarted
      def empty?
        true
      end

      def method_missing(*)
        raise NoCommandHasBeenStartedError, 'No last command started available'
      end

      def respond_to_missing?(*)
        true
      end
    end

    def initialize(opts = {})
      @registered_commands = []
      @announcer = opts.fetch(:announcer)

      @last_command_stopped = DefaultLastCommandStopped.new
      @last_command_started = DefaultLastCommandStarted.new
    rescue KeyError => e
      raise ArgumentError, e.message
    end

    # Set last command started
    #
    # @param [String] cmd
    #   The commandline of the command
    def last_command_started=(cmd)
      @last_command_started = find(cmd)
    end

    # Set last command stopped
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

      raise CommandNotFoundError, "No command named '#{cmd}' has been started" if command.nil?

      command
    end

    # Clear list of known commands
    def clear
      registered_commands.each(&:terminate)
      registered_commands.clear

      self
    end

    # Get stdout of all commands
    #
    # @return [String]
    #   The stdout of all command which have run before
    def all_stdout
      registered_commands.each(&:stop)

      registered_commands.map(&:stdout).join
    end

    # Get stderr of all commands
    #
    # @return [String]
    #   The stderr of all command which have run before
    def all_stderr
      registered_commands.each(&:stop)

      registered_commands.map(&:stderr).join
    end

    # Get stderr and stdout of all commands
    #
    # @return [String]
    #   The stderr and stdout of all command which have run before
    def all_output
      all_stdout << all_stderr
    end

    # Register command to monitor
    def register_command(cmd)
      registered_commands << cmd

      self
    end
  end
end
