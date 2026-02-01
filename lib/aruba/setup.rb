# frozen_string_literal: true

module Aruba
  class Setup
    private

    attr_reader :runtime

    public

    def initialize(runtime)
      @runtime = runtime
    end

    def call(clobber = true)
      return if runtime.setup_already_done?

      working_directory(clobber)
      register_event_handlers

      runtime.setup_done

      self
    end

    private

    def working_directory(clobber = true)
      if clobber
        Aruba.platform.rm File.join(runtime.config.root_directory,
                                    runtime.config.working_directory),
                          force: true
      end
      Aruba.platform.mkdir File.join(runtime.config.root_directory,
                                     runtime.config.working_directory)
      Aruba.platform.chdir runtime.config.root_directory
    end

    def handle_command_started(event)
      runtime.announcer.announce(:command) { event.entity.commandline }
      runtime.announcer.announce(:timeout, 'exit') { event.entity.exit_timeout }
      runtime.announcer.announce(:timeout, 'io wait') { event.entity.io_wait_timeout }
      runtime.announcer
             .announce(:wait_time, 'startup wait time') { event.entity.startup_wait_time }
      runtime.announcer.announce(:full_environment) { event.entity.environment }

      runtime.command_monitor.register_command event.entity
      runtime.command_monitor.last_command_started = event.entity
    end

    def handle_command_stopped(event)
      runtime.announcer.announce(:stdout) { event.entity.stdout }
      runtime.announcer.announce(:stderr) { event.entity.stderr }
      runtime.announcer.announce(:command_content) { event.entity.content }
      runtime.announcer
             .announce(:command_filesystem_status) { event.entity.filesystem_status }

      runtime.command_monitor.last_command_stopped = event.entity
    end

    def handle_changed_environment_variable(event)
      runtime.announcer.announce :changed_environment,
                                 event.entity[:changed][:name],
                                 event.entity[:changed][:value]
      runtime.announcer.announce :environment,
                                 event.entity[:changed][:name],
                                 event.entity[:changed][:value]
    end

    def handle_changed_working_directory(event)
      runtime.announcer.announce :directory, event.entity[:new]
    end

    def handle_changed_configuration(event)
      runtime.announcer.announce :configuration,
                                 event.entity[:changed][:name],
                                 event.entity[:changed][:value]
    end

    def register_event_handlers
      bus = runtime.event_bus
      bus.register(:command_started) { handle_command_started _1 }
      bus.register(:command_stopped) { handle_command_stopped _1 }
      bus.register(%i[changed_environment_variable
                      added_environment_variable
                      deleted_environment_variable]) \
                        { handle_changed_environment_variable _1 }
      bus.register(:changed_working_directory) { handle_changed_working_directory _1 }
      bus.register(:changed_configuration) { handle_changed_configuration _1 }
    end
  end
end
