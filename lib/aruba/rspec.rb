# frozen_string_literal: true

require 'rspec/core'

require 'aruba'
require 'aruba/api'
require 'aruba/version'

RSpec.configure do |config|
  config.include Aruba::Api, type: :aruba

  # Setup environment for aruba
  config.around :each do |example|
    if self.class.include? Aruba::Api
      setup_aruba

      # Modify PATH to include project/bin
      prepend_environment_variable(
        'PATH',
        aruba.config.command_search_paths.join(File::PATH_SEPARATOR) + File::PATH_SEPARATOR
      )

      # Use configured home directory as HOME
      set_environment_variable 'HOME', aruba.config.home_directory
    end

    example.run

    next unless self.class.include? Aruba::Api

    stop_all_commands
  end

  config.around :each do |example|
    if self.class.include? Aruba::Api
      with_environment do
        example.run
      end
    else
      example.run
    end
  end

  config.before :each do |example|
    next unless self.class.include? Aruba::Api

    example.metadata.each { |k, v| aruba.config.set_if_option(k, v) }
  end

  # Activate announcers based on rspec metadata
  config.before :each do |example|
    next unless self.class.include?(Aruba::Api)

    if example.metadata[:announce_full_environment]
      aruba.announcer.activate(:full_environment)
    end
    if example.metadata[:announce_changed_environment]
      aruba.announcer.activate(:changed_environment)
    end

    aruba.announcer.activate(:command) if example.metadata[:announce_command]
    aruba.announcer.activate(:directory) if example.metadata[:announce_directory]
    if example.metadata[:announce_full_environment]
      aruba.announcer.activate(:full_environment)
    end
    aruba.announcer.activate(:stderr) if example.metadata[:announce_stderr]
    aruba.announcer.activate(:stdout) if example.metadata[:announce_stdout]
    aruba.announcer.activate(:stop_signal) if example.metadata[:announce_stop_signal]
    aruba.announcer.activate(:timeout) if example.metadata[:announce_timeout]
    aruba.announcer.activate(:wait_time) if example.metadata[:announce_wait_time]
    aruba.announcer.activate(:command_content) if example.metadata[:announce_command_content]
    if example.metadata[:announce_command_filesystem_status]
      aruba.announcer.activate(:command_filesystem_status)
    end

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
end
