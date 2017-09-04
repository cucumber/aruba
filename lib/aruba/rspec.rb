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
  config.around :each do |example|
    if self.class.include? Aruba::Api
      setup_aruba
    end

    example.run

    next unless self.class.include? Aruba::Api
    stop_all_commands
  end

  if Aruba::VERSION >= '1.0.0'
    config.around :each do |example|
      Aruba.platform.with_environment do
        example.run
      end
    end
  end

  config.before :each do |example|
    next unless self.class.include? Aruba::Api

    example.metadata.each { |k, v| aruba.config.set_if_option(k, v) }
  end

  # Activate announcers based on rspec metadata
  config.before :each do |example|
    next unless self.class.include?(Aruba::Api)

    if example.metadata[:announce_environment]
      Aruba.platform.deprecated 'announce_environment is deprecated. Use announce_changed_environment instead'

      aruba.announcer.activate(:changed_environment)
    end

    aruba.announcer.activate(:full_environment)     if example.metadata[:announce_full_environment]
    aruba.announcer.activate(:changed_environment)  if example.metadata[:announce_changed_environment]

    if example.metadata[:announce_modified_environment]
      Aruba.platform.deprecated 'announce_modified_environment is deprecated. Use announce_changed_environment instead'

      aruba.announcer.activate(:changed_environment)
    end

    aruba.announcer.activate(:command)                   if example.metadata[:announce_command]
    aruba.announcer.activate(:directory)                 if example.metadata[:announce_directory]
    aruba.announcer.activate(:full_environment)          if example.metadata[:announce_full_environment]
    aruba.announcer.activate(:stderr)                    if example.metadata[:announce_stderr]
    aruba.announcer.activate(:stdout)                    if example.metadata[:announce_stdout]
    aruba.announcer.activate(:stop_signal)               if example.metadata[:announce_stop_signal]
    aruba.announcer.activate(:timeout)                   if example.metadata[:announce_timeout]
    aruba.announcer.activate(:wait_time)                 if example.metadata[:announce_wait_time]
    aruba.announcer.activate(:command_content)           if example.metadata[:announce_command_content]
    aruba.announcer.activate(:command_filesystem_status) if example.metadata[:announce_command_filesystem_status]

    if example.metadata[:announce_output]
      aruba.announcer.activate(:stderr)
      aruba.announcer.activate(:stdout)
    end

    if example.metadata[:announce]
      aruba.announcer.activate(:changed_environment)
      aruba.announcer.activate(:command)
      aruba.announcer.activate(:directory)
      aruba.announcer.activate(:environment)
      aruba.announcer.activate(:full_environment)
      aruba.announcer.activate(:stderr)
      aruba.announcer.activate(:stdout)
      aruba.announcer.activate(:stop_signal)
      aruba.announcer.activate(:timeout)
      aruba.announcer.activate(:wait_time)
      aruba.announcer.activate(:command_content)
      aruba.announcer.activate(:command_filesystem_status)
    end
  end

  # Modify PATH to include project/bin
  config.before :each do
    next unless self.class.include? Aruba::Api

    prepend_environment_variable 'PATH', aruba.config.command_search_paths.join(':') + ':'
  end

  # Use configured home directory as HOME
  config.before :each do |example|
    next unless self.class.include? Aruba::Api

    set_environment_variable 'HOME', aruba.config.home_directory
  end
end
