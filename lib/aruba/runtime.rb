module Aruba
  class Runtime
    attr_reader :config, :command_monitor, :announcer, :event_queue

    def initialize
      @config          = Aruba.config.deep_dup
      @event_queue     = Aruba::EventQueue.new
      @announcer       = Aruba::Announcer.new
      @command_monitor = Aruba::CommandMonitor.new(@announcer)

      # register_events
    end

    private

    def register_events
      event_queue.register :command_started, announcer
      event_queue.register :command_stopped, announcer
      event_queue.register :add_environment_variable, announcer
      event_queue.register :switched_working_directory, announcer
      event_queue.register :switched_working_directory, command_monitor
    end
  end
end
