require 'aruba/aruba_path'
require 'aruba/api'
require 'aruba/platform'
World(Aruba::Api)

if Aruba::VERSION >= '1.0.0'
  Around do |_, block|
    Aruba.platform.with_environment(&block)
  end
end

Before do
  # ... so every change needs to be done later
  prepend_environment_variable 'PATH', aruba.config.command_search_paths.join(File::PATH_SEPARATOR) + File::PATH_SEPARATOR
  set_environment_variable 'HOME', aruba.config.home_directory
end

After do
  terminate_all_commands
  aruba.command_monitor.clear
end

Before('@no-clobber') do
  setup_aruba(false)
end

Before('~@no-clobber') do
  setup_aruba
end

Before('@puts') do
  aruba.announcer.mode = :puts
end

Before('@announce-command') do
  aruba.announcer.activate :command
end

Before('@announce-command-content') do
  aruba.announcer.activate :command_content
end

Before('@announce-command-filesystem-status') do
  aruba.announcer.activate :command_filesystem_status
end

Before('@announce-cmd') do
  Aruba.platform.deprecated 'The use of "@announce-cmd"-hook is deprecated. Please use "@announce-command"'

  aruba.announcer.activate :command
end

Before('@announce-output') do
  aruba.announcer.activate :stdout
  aruba.announcer.activate :stderr
end

Before('@announce-stdout') do
  aruba.announcer.activate :stdout
end

Before('@announce-stderr') do
  aruba.announcer.activate :stderr
end

Before('@announce-dir') do
  Aruba.platform.deprecated 'The use of "@announce-dir"-hook is deprecated. Please use "@announce-directory"'

  aruba.announcer.activate :directory
end

Before('@announce-directory') do
  aruba.announcer.activate :directory
end

Before('@announce-stop-signal') do
  aruba.announcer.activate :stop_signal
end

Before('@announce-env') do
  Aruba.platform.deprecated 'The use of "@announce-env"-hook is deprecated. Please use "@announce-changed-environment"'

  aruba.announcer.activate :environment
end

Before('@announce-environment') do
  Aruba.platform.deprecated '@announce-environment is deprecated. Use @announce-changed-environment instead'

  aruba.announcer.activate :changed_environment
end

Before('@announce-full-environment') do
  aruba.announcer.activate :full_environment
end

Before('@announce-modified-environment') do
  Aruba.platform.deprecated '@announce-modified-environment is deprecated. Use @announce-changed-environment instead'

  aruba.announcer.activate :changed_environment
end

Before('@announce-changed-environment') do
  aruba.announcer.activate :changed_environment
end

Before('@announce-timeout') do
  aruba.announcer.activate :timeout
end

Before('@announce-wait-time') do
  aruba.announcer.activate :wait_time
end

Before('@announce') do
  aruba.announcer.activate :changed_environment
  aruba.announcer.activate :command
  aruba.announcer.activate :directory
  aruba.announcer.activate :environment
  aruba.announcer.activate :full_environment
  aruba.announcer.activate :modified_environment
  aruba.announcer.activate :stderr
  aruba.announcer.activate :stdout
  aruba.announcer.activate :stop_signal
  aruba.announcer.activate :timeout
  aruba.announcer.activate :wait_time
  aruba.announcer.activate :command_content
  aruba.announcer.activate :command_filesystem_status
end

Before('@debug') do
  aruba.config.command_launcher = :debug
end

# After('@debug') do
#   aruba.config.command_launcher = :spawn
# end

Before('@ansi') do
  # rubocop:disable Metrics/LineLength
  Aruba::Platform.deprecated('The use of "@ansi" is deprecated. Use "@keep-ansi-escape-sequences" instead. But be aware, that this hook uses the aruba configuration and not an instance variable')
  # rubocop:enable Metrics/LineLength

  aruba.config.remove_ansi_escape_sequences = false
end

Before('@keep-ansi-escape-sequences') do
  aruba.config.remove_ansi_escape_sequences = false
  aruba.config.keep_ansi = true
end

Before '@mocked_home_directory' do
  Aruba.platform.deprecated('The use of "@mocked_home_directory" is deprecated. Use "@mocked-home-directory" instead')

  set_environment_variable 'HOME', expand_path('.')
end

Before '@mocked-home-directory' do
  set_environment_variable 'HOME', expand_path('.')
end

Before('@disable-bundler') do
  unset_bundler_env_vars
end
