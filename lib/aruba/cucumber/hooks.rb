Around do |_, block|
  project_bin = aruba.config.root_directory.dup << 'bin'
  old_path    = ENV.fetch 'PATH', ''

  paths = old_path.split(File::PATH_SEPARATOR)
  paths << project_bin

  ENV['PATH'] = paths.join(File::PATH_SEPARATOR)

  block.call

  ENV['PATH'] = old_path

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

Before('@announce') do
  announcer.activate :command
  announcer.activate :stdout
  announcer.activate :stderr
  announcer.activate :directory
  announcer.activate :environment
end

Before('@debug') do
  require 'aruba/processes/debug_process'
  Aruba.process = Aruba::Processes::DebugProcess
end

Before('@ansi') do
  @aruba_keep_ansi = true
end

Before '@mocked_home_directory' do
  set_env 'HOME', expand_path('.')
end

Before('@disable-bundler') do
  unset_bundler_env_vars
end

