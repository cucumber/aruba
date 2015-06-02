module Aruba
  class Runtime
    attr_reader :config, :command_monitor, :announcer, :event_manager

    def initialize
      @config          = Aruba.config.deep_dup
      @announcer       = Aruba::Announcer.new
      @command_monitor = Aruba::CommandMonitor.new(@announcer)

      @event_manager   = Aruba::Queue.new

      @event_manager.register :command_started, @announcer
      @event_manager.register :command_stopped, @announcer
      @event_manager.register :add_environment_variable, @announcer
      @event_manager.register :switched_working_directory, @announcer
      @event_manager.register :switched_working_directory, @command_monitor
    end
  end
end
