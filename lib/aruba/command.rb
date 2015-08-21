require 'delegate'
require 'aruba/processes/spawn_process'
require 'aruba/processes/in_process'
require 'aruba/processes/debug_process'

module Aruba
  class Command < SimpleDelegator
    private

    attr_reader :event_bus

    public

    # rubocop:disable Metrics/MethodLength
    def initialize(command, opts = {})
      launchers = []
      launchers << Processes::DebugProcess
      launchers << Processes::InProcess
      launchers << Processes::SpawnProcess

      launcher = launchers.find { |l| l.match? opts[:mode] }

      super launcher.new(
        command,
        opts.fetch(:exit_timeout),
        opts.fetch(:io_wait_timeout),
        opts.fetch(:working_directory),
        opts.fetch(:environment),
        opts.fetch(:main_class),
        opts.fetch(:stop_signal),
        opts.fetch(:startup_wait_time)
      )

      @event_bus = opts.fetch(:event_bus)
    rescue KeyError => e
      raise ArgumentError, e.message
    end
    # rubocop:enable Metrics/MethodLength

    # Stop command
    def stop(*)
      __getobj__.stop
      event_bus.notify Events::CommandStopped.new(self)

      self
    end

    # Terminate command
    def terminate(*)
      __getobj__.terminate
      event_bus.notify Events::CommandStopped.new(self)

      self
    end

    # Start command
    def start
      __getobj__.start
      event_bus.notify Events::CommandStarted.new(self)

      self
    end
    alias_method :run!, :start
  end
end
