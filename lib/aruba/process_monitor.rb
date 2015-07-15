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
      return @last_exit_status if @last_exit_status
      stop_processes!
      @last_exit_status
    end

    def stop_process(process)
      @last_exit_status = process.stop(announcer)
    end

    def terminate_process!(process)
      process.terminate
    end

    def stop_processes!
      processes.each do |_, process|
        @last_exit_status = stop_process(process)
      end
    end

    # Terminate all running processes
    def terminate_processes
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
      processes.collect{ |_, process| process }
    end

    # Fetch output (stdout, stderr) from command
    #
    # @param [String] cmd
    #   The command
    def output_from(cmd)
      cmd = Platform.detect_ruby(cmd)
      get_process(cmd).output
    end

    # Fetch stdout from command
    #
    # @param [String] cmd
    #   The command
    def stdout_from(cmd)
      cmd = Platform.detect_ruby(cmd)
      get_process(cmd).stdout
    end

    # Fetch stderr from command
    #
    # @param [String] cmd
    #   The command
    def stderr_from(cmd)
      cmd = Platform.detect_ruby(cmd)
      get_process(cmd).stderr
    end

    # Get stdout of all processes
    #
    # @return [String]
    #   The stdout of all process which have run before
    def all_stdout
      stop_processes!

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
      stop_processes!

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
      all_stdout << all_stderr
    end

    def clear
      processes.clear
    end
  end
end
