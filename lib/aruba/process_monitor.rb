module Aruba
  class ProcessMonitor
    private

    attr_reader :processes, :announcer

    public

    def initialize(announcer)
      @processes = []
      @announcer = announcer
    end

    def last_exit_status
      Aruba::Platform.deprecated('The use of "#last_exit_status" is deprecated. Use "last_command_(started|stopped).exit_status" instead')

      return @last_exit_status if @last_exit_status
      all_commands.each { |c| c.stop(announcer) }
      @last_exit_status
    end

    def last_command_stopped
      return @last_command_stopped if @last_command_stopped

      all_commands.each { |c| c.stop(announcer) }

      @last_command_stopped
    end

    def last_command_started
      processes.last[1]
    end

    def stop_process(process)
      @last_command_stopped = process
      @last_exit_status     = process.stop(announcer)
    end

    def terminate_process!(process)
      process.terminate
    end

    def stop_processes!
      Aruba::Platform.deprecated('The use of "#stop_processes!" is deprecated. Use "#all_commands.each { |c| c.stop(announcer) }" instead')

      all_commands.each(&:stop)
    end

    # Terminate all running processes
    def terminate_processes
      Aruba::Platform.deprecated('The use of "#terminate_processes" is deprecated. Use "#all_commands.each(&:terminate)" instead')

      processes.each do |_, process|
        terminate_process(process)
        stop_process(process)
      end
    end

    def register_process(name, process)
      processes << [name, process]

      [name, process]
    end

    def get_process(wanted)
      matching_processes = processes.reverse.find{ |name, _| name == wanted }
      raise ArgumentError.new("No process named '#{wanted}' has been started") unless matching_processes
      matching_processes.last
    end

    def only_processes
      Aruba::Platform.deprecated('The use of "#only_processes" is deprecated. Use "#all_commands" instead')

      processes.collect{ |_, process| process }
    end

    # Fetch output (stdout, stderr) from command
    #
    # @param [String] cmd
    #   The command
    def output_from(cmd)
      cmd = Aruba.platform.detect_ruby(cmd)
      get_process(cmd).output
    end

    # Fetch stdout from command
    #
    # @param [String] cmd
    #   The command
    def stdout_from(cmd)
      cmd = Aruba.platform.detect_ruby(cmd)
      get_process(cmd).stdout
    end

    # Fetch stderr from command
    #
    # @param [String] cmd
    #   The command
    def stderr_from(cmd)
      cmd = Aruba.platform.detect_ruby(cmd)
      get_process(cmd).stderr
    end

    # Get stdout of all processes
    #
    # @return [String]
    #   The stdout of all process which have run before
    def all_stdout
      # rubocop:disable Metrics/LineLength
      Aruba::Platform.deprecated('The use of "#all_stdout" is deprecated. Use `all_commands.map { |c| c.stdout }.join("\n") instead. If you need to check for some output use "expect(all_commands).to have_output_on_stdout /output/" instead')
      # rubocop:enable Metrics/LineLength

      all_commands.each { |c| c.stop(announcer) }

      if RUBY_VERSION < '1.9'
        out = ''
        only_processes.each { |ps| out << ps.stdout }

        out
      else
        only_processes.each_with_object("") { |ps, o| o << ps.stdout }
      end
    end

    # Get stderr of all processes
    #
    # @return [String]
    #   The stderr of all process which have run before
    def all_stderr
      # rubocop:disable Metrics/LineLength
      Aruba::Platform.deprecated('The use of "#all_stderr" is deprecated. Use `all_commands.map { |c| c.stderr }.join("\n") instead. If you need to check for some output use "expect(all_commands).to have_output_on_stderr /output/" instead')
      # rubocop:enable Metrics/LineLength

      all_commands.each { |c| c.stop(announcer) }

      if RUBY_VERSION < '1.9'
        out = ''
        only_processes.each { |ps| out << ps.stderr }

        out
      else
        only_processes.each_with_object("") { |ps, o| o << ps.stderr }
      end
    end

    # Get stderr and stdout of all processes
    #
    # @return [String]
    #   The stderr and stdout of all process which have run before
    def all_output
      # rubocop:disable Metrics/LineLength
      Aruba::Platform.deprecated('The use of "#all_output" is deprecated. Use `all_commands.map { |c| c.output }.join("\n") instead. If you need to check for some output use "expect(all_commands).to have_output /output/" instead')
      # rubocop:enable Metrics/LineLength

      all_stdout << all_stderr
    end

    # Return all commands
    #
    # @return [Array]
    #   A list of all commands
    def all_commands
      processes.collect{ |_, process| process }
    end

    # Clear list of processes
    def clear
      processes.clear

      self
    end
  end
end
