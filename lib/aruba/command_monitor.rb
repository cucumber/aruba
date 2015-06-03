module Aruba
  class CommandMonitor
    private

    attr_reader :commands, :event_manager

    public

    def initialize(event_manager: nil)
      fail ArgumentError, 'event_manager is required' if event_manager.nil?

      @commands = []
      @event_manager = event_manager
    end

    def last_exit_status
      return @last_exit_status if @last_exit_status
      stop_commands
      @last_exit_status
    end

    def start_command(cmd, timeout, io_wait, working_directory)
      event_manager.notify :command_started, cmd

      command = Aruba.process.new(cmd, timeout, io_wait, working_directory)
      register_command(command)
      command.start

      command
    end

    def stop_command(cmd)
      event_manager.notify :command_stopped, cmd

      find(cmd) { |c| c.stop }
    end

    def terminate_command(cmd)
      event_manager.notify :command_stopped, cmd

      find(cmd) { |c| c.terminate }
    end

    def find(cmd)
      command = commands.find { |c| c.commandline == cmd }

      fail ArgumentError "No command named '#{cmd}' has been started" if command.nil?

      yield(command)
    end

    def stop_commands
      commands.each do |c|
        event_manager.notify :command_stopped, c.commandline
        c.stop
      end
    end

    # Terminate all running commands
    def terminate_commands
      commands.each do |c|
        event_manager.notify :command_stopped, c.commandline
        c.terminate
      end
    end

    def register_command(cmd)
      commands << cmd
    end

    # Fetch output (stdout, stderr) from command
    #
    # @param [String] cmd
    #   The command
    def output_from(cmd)
      cmd = Utils.detect_ruby(cmd)
      find(cmd).output
    end

    # Fetch stdout from command
    #
    # @param [String] cmd
    #   The command
    def stdout_from(cmd)
      cmd = Utils.detect_ruby(cmd)
      find(cmd).stdout
    end

    # Fetch stderr from command
    #
    # @param [String] cmd
    #   The command
    def stderr_from(cmd)
      cmd = Utils.detect_ruby(cmd)
      find(cmd).stderr
    end

    # Get stdout of all commands
    #
    # @return [String]
    #   The stdout of all command which have run before
    def all_stdout
      stop_commands
      commands.each_with_object("") { |ps, out| out << ps.stdout }
    end

    # Get stderr of all commands
    #
    # @return [String]
    #   The stderr of all command which have run before
    def all_stderr
      stop_commands
      commands.each_with_object("") { |ps, out| out << ps.stderr }
    end

    # Get stderr and stdout of all commands
    #
    # @return [String]
    #   The stderr and stdout of all command which have run before
    def all_output
      all_stdout << all_stderr
    end

    def clear
      commands.clear
    end
  end
end
