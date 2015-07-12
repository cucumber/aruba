require 'aruba/aruba_path'
require 'aruba/api'
World(Aruba::Api)

# Activate on 1.0.0
#
# Around do |_, block|
#   begin
#     if RUBY_VERSION < '1.9'
#       old_env = ENV.to_hash
#     else
#       old_env = ENV.to_h
#     end
#
#     block.call
#   ensure
#     ENV.clear
#     ENV.update old_env
#   end
# end

Before do
  aruba.environment.update aruba.config.command_runtime_environment
  prepend_environment_variable 'PATH', aruba.config.command_search_paths.join(':') + ':'
end

After do
  restore_env
  process_monitor.stop_processes!
  process_monitor.clear
end

Before('~@no-clobber') do
  setup_aruba
end

Before('@puts') do
  announcer.mode = :puts
end

Before('@announce-command') do
  announcer.activate :command
end

Before('@announce-cmd') do
  Aruba::Platform.deprecated 'The use of "@announce-cmd"-hook is deprecated. Please use "@announce-command"'

  announcer.activate :command
end

Before('@announce-stdout') do
  announcer.activate :stdout
end

Before('@announce-stderr') do
  announcer.activate :stderr
end

Before('@announce-dir') do
  Aruba::Platform.deprecated 'The use of "@announce-dir"-hook is deprecated. Please use "@announce-directory"'

  announcer.activate :directory
end

Before('@announce-directory') do
  announcer.activate :directory
end

Before('@announce-env') do
  Aruba::Platform.deprecated 'The use of "@announce-env"-hook is deprecated. Please use "@announce-environment"'

  announcer.activate :environment
end

Before('@announce-environment') do
  announcer.activate :environment
end

Before('@announce-timeout') do
  announcer.activate :timeout
end

Before('@announce') do
  announcer.activate :command
  announcer.activate :stdout
  announcer.activate :stderr
  announcer.activate :directory
  announcer.activate :environment
  announcer.activate :timeout
end

Before('@debug') do
  aruba.config.command_launcher = :debug
end

# After('@debug') do
#   aruba.config.command_launcher = :spawn
# end

Before('@ansi') do
  @aruba_keep_ansi = true
end

Before '@mocked_home_directory' do
  Aruba::Platform.deprecated('The use of "@mocked_home_directory" is deprecated. Use "@mocked-home-directory" instead')

  set_environment_variable 'HOME', expand_path('.')
end

Before '@mocked-home-directory' do
  set_environment_variable 'HOME', expand_path('.')
end

Before('@disable-bundler') do
  unset_bundler_env_vars
end
