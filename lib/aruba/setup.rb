module Aruba
  class Setup
    private

    attr_reader :runtime

    public

    def initialize(runtime)
      @runtime      = runtime
    end

    def call
      return if runtime.setup_already_done?

      working_directory
      events

      runtime.setup_done

      self
    end

    private

    def working_directory
      Aruba.platform.rm File.join(runtime.config.root_directory, runtime.config.working_directory), :force => true
      Aruba.platform.mkdir File.join(runtime.config.root_directory, runtime.config.working_directory)
      Aruba.platform.chdir runtime.config.root_directory
    end

    # rubocop:disable Metrics/MethodLength
    def events
      runtime.event_bus.register(
        :command_started,
        ->(event) do
          runtime.announcer.announce :command, event.entity.commandline
          runtime.announcer.announce :timeout, 'exit', event.entity.exit_timeout
          runtime.announcer.announce :timeout, 'io wait', event.entity.io_wait_timeout
          runtime.announcer.announce :full_environment, event.entity.environment
        end
      )

      runtime.event_bus.register(
        :command_started,
        ->(event) do
          runtime.command_monitor.last_command_started = event.entity
        end
      )

      runtime.event_bus.register(
        :command_stopped,
        ->(event) do
          runtime.announcer.announce :stdout, event.entity.stdout
          runtime.announcer.announce :stderr, event.entity.stderr
        end
      )

      runtime.event_bus.register(
        :command_stopped,
        ->(event) do
          runtime.command_monitor.last_command_stopped = event.entity
        end
      )

      runtime.event_bus.register(
        [:changed_environment_variable, :added_environment_variable, :deleted_environment_variable],
        ->(event) do
          runtime.announcer.announce :changed_environment, event.entity[:changed][:name], event.entity[:changed][:value]
          runtime.announcer.announce :environment, event.entity[:changed][:name], event.entity[:changed][:value]
        end
      )

      runtime.event_bus.register(
        :changed_working_directory,
        ->(event) { runtime.announcer.announce :directory, event.entity[:new] }
      )

      runtime.event_bus.register(
        :changed_configuration,
        ->(event) { runtime.announcer.announce :configuration, event.entity[:changed][:name], event.entity[:changed][:value] }
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
