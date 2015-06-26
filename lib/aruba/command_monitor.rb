module Aruba
  class CommandMonitor
    private

    attr_reader :event_queue

    public

    attr_reader :commands

    def initialize(event_queue: nil)
      fail ArgumentError, 'event_queue is required' if event_queue.nil?

      @commands = []
      @event_queue = event_queue
    end

    def last_exit_status
      return @last_exit_status if @last_exit_status
      stop_commands
      @last_exit_status
    end

    # The last started command
    def last_command
      commands.last
    end

    # Start given command
    #
    # @param [String] cmd
    #   The commandline of the command
    # @param [Numeric] timeout
    #   The time to wait for the command to stop
    def start_command(cmd, timeout, io_wait, working_directory)
      command = ArubaCommand.new(Aruba.process.new(cmd, timeout, io_wait, working_directory), event_queue)
      register_command(command)
      command.start

      command
    end

    # Stop given command
    #
    # @param [String] cmd
    #   The commandline of the command
    def stop_command(cmd)
      find(cmd) { |c| c.stop }
    end

    # Terminate given command
    #
    # @param [String] cmd
    #   The commandline of the command
    def terminate_command(cmd)
      find(cmd) { |c| c.terminate }
    end

    # Find command
    #
    # @yield [Command]
    #   This yields the found command
    def find(cmd)
      cmd = cmd.commandline if cmd.is_a? ArubaCommand
      command = commands.find { |c| c.commandline == cmd }

      fail ArgumentError, "No command named '#{cmd}' has been started" if command.nil?

      yield(command)
    end

    # Stop all known commands
    def stop_commands
      commands.each do |c|
        c.stop
      end

      self
    end

    # Terminate all running commands
    def terminate_commands
      commands.each do |c|
        c.terminate
      end

      self
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

    # Clear list of known commands
    def clear
      stop_commands
      commands.clear

      self
    end

    private

    # Register
    def register_command(cmd)
      commands << cmd
    end

  end
end
