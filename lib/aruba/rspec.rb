require 'rspec/core'

require 'aruba'
require 'aruba/api'
require 'aruba/version'

if Aruba::VERSION >= '1.0.0'
  Aruba.configure do |config|
    config.working_directory = 'tmp/rspec'
  end
end

RSpec.configure do |config|
  config.include Aruba::Api, :type => :aruba

  # Setup environment for aruba
  config.before :each do
    next unless self.class.include? Aruba::Api

    restore_env
    setup_aruba
  end

  if Aruba::VERSION >= '1.0.0'
    config.around :each do |example|
      begin
        old_env = ENV.to_hash
        example.run
      ensure
        ENV.clear
        ENV.update old_env
      end
    end
  end

  # Use rspec metadata as option for aruba
  config.before :each do |example|
    next unless self.class.include? Aruba::Api

    example.metadata.each { |k, v| aruba.config.set_if_option(k, v) }
  end

  # Activate announcers based on rspec metadata
  config.before :each do |example|
    next unless self.class.include?(Aruba::Api)

    if example.metadata[:announce_environment]
      Aruba::Platform.deprecated 'announce_environment is deprecated. Use announce_modified_environment instead'

      announcer.activate(:modified_environment)
    end

    announcer.activate(:full_environment)     if example.metadata[:announce_full_environment]
    announcer.activate(:modified_environment) if example.metadata[:announce_modified_environment]
    announcer.activate(:command)              if example.metadata[:announce_command]
    announcer.activate(:directory)            if example.metadata[:announce_directory]
    announcer.activate(:stdout)               if example.metadata[:announce_stdout]
    announcer.activate(:stderr)               if example.metadata[:announce_stderr]

    if example.metadata[:announce_output]
      announcer.activate(:stderr)
      announcer.activate(:stdout)
    end

    if example.metadata[:announce]
      announcer.activate(:stderr)
      announcer.activate(:stdout)
      announcer.activate(:environment)
      announcer.activate(:modified_environment)
      announcer.activate(:full_environment)
      announcer.activate(:command)
      announcer.activate(:directory)
    end
  end

  # Modify PATH to include project/bin
  config.before :each do
    next unless self.class.include? Aruba::Api

    aruba.environment.update aruba.config.command_runtime_environment
    aruba.environment.prepend 'PATH', aruba.config.command_search_paths.join(':') + ':'
  end

  # Use configured home directory as HOME
  config.before :each do |example|
    next unless self.class.include? Aruba::Api

    aruba.environment['HOME'] =  aruba.config.home_directory
  end
end
