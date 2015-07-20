require 'aruba/aruba_path'
require 'aruba/api'
World(Aruba::Api)

if Aruba::VERSION >= '1.0.0'
  Around do |_, block|
    begin
      if RUBY_VERSION < '1.9'
        old_env = ENV.to_hash
      else
        old_env = ENV.to_h
      end

      block.call
    ensure
      ENV.clear
      ENV.update old_env
    end
  end
end

Before do
  aruba_scope do
    # this is ENV by default ...
    aruba.environment.update aruba.config.command_runtime_environment

    # ... so every change needs to be done later
    prepend_environment_variable 'PATH', aruba.config.command_search_paths.join(':') + ':'
    set_environment_variable 'HOME', aruba.config.home_directory
  end
end

After do
  aruba_scope do
    restore_env
    process_monitor.stop_processes!
    process_monitor.clear
  end
end

Before('~@no-clobber') do
  aruba_scope do
    setup_aruba
  end
end

Before('@puts') do
  aruba_scope do
    announcer.mode = :puts
  end
end

Before('@announce-command') do
  aruba_scope do
    announcer.activate :command
  end
end

Before('@announce-cmd') do
  Aruba::Platform.deprecated 'The use of "@announce-cmd"-hook is deprecated. Please use "@announce-command"'

  aruba_scope do
    announcer.activate :command
  end
end

Before('@announce-stdout') do
  aruba_scope do
    announcer.activate :stdout
  end
end

Before('@announce-stderr') do
  aruba_scope do
    announcer.activate :stderr
  end
end

Before('@announce-dir') do
  Aruba::Platform.deprecated 'The use of "@announce-dir"-hook is deprecated. Please use "@announce-directory"'

  aruba_scope do
    announcer.activate :directory
  end
end

Before('@announce-directory') do
  aruba_scope do
    announcer.activate :directory
  end
end

Before('@announce-env') do
  Aruba::Platform.deprecated 'The use of "@announce-env"-hook is deprecated. Please use "@announce-modified-environment"'

  aruba_scope do
    announcer.activate :environment
  end
end

Before('@announce-environment') do
  Aruba::Platform.deprecated '@announce-environment is deprecated. Use @announce-modified-environment instead'

  aruba_scope do
    announcer.activate :modified_environment
  end
end

Before('@announce-full-environment') do
  aruba_scope do
    announcer.activate :full_environment
  end
end

Before('@announce-modified-environment') do
  aruba_scope do
    announcer.activate :modified_environment
  end
end

Before('@announce-timeout') do
  aruba_scope do
    announcer.activate :timeout
  end
end

Before('@announce') do
  aruba_scope do
    announcer.activate :command
    announcer.activate :stdout
    announcer.activate :stderr
    announcer.activate :directory
    announcer.activate :modified_environment
    announcer.activate :full_environment
    announcer.activate :environment
    announcer.activate :timeout
  end
end

Before('@debug') do
  aruba_scope do
    aruba.config.command_launcher = :debug
  end
end

# After('@debug') do
#   aruba.config.command_launcher = :spawn
# end

Before('@ansi') do
  @aruba_keep_ansi = true
end

Before '@mocked_home_directory' do
  Aruba::Platform.deprecated('The use of "@mocked_home_directory" is deprecated. Use "@mocked-home-directory" instead')

  aruba_scope do
    set_environment_variable 'HOME', expand_path('.')
  end
end

Before '@mocked-home-directory' do
  aruba_scope do
    set_environment_variable 'HOME', expand_path('.')
  end
end

Before('@disable-bundler') do
  aruba_scope do
    unset_bundler_env_vars
  end
end
