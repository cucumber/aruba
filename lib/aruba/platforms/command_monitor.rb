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

    def initialize(opts = {})
      @registered_commands = []
      @announcer = opts.fetch(:announcer)

      @last_command_stopped = DefaultLastCommandStopped.new
      @last_command_started = DefaultLastCommandStarted.new

    rescue KeyError => e
      raise ArgumentError, e.message
    end

    attr_reader :last_command_stopped

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

      fail CommandNotFoundError, "No command named '#{cmd}' has been started" if command.nil?

      command
    end

    # Clear list of known commands
    def clear
      registered_commands.each(&:terminate)
      registered_commands.clear

      self
    end

    # Register command to monitor
    def register_command(cmd)
      registered_commands << cmd

      self
    end
  end
end
