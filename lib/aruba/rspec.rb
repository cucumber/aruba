require 'rspec/core'

require 'aruba'
require 'aruba/api'

RSpec.configure do |config|
  config.include Aruba::Api, type: :aruba

  config.before :each do
    next unless self.class.include? Aruba::Api

    restore_env
    setup_aruba
  end

  config.around :each do |example|
    old_env = ENV.to_h
    example.run
    ENV.update old_env
  end

  config.before :each do |example|
    next unless self.class.include? Aruba::Api

    example.metadata.each { |k, v| aruba.config.set_if_option(k, v) }
  end

  config.before :each do |example|
    next unless self.class.include?(Aruba::Api)

    announcer.activate(:environment) if example.metadata[:announce_environment]
    announcer.activate(:command)     if example.metadata[:announce_command]
    announcer.activate(:directory)   if example.metadata[:announce_directory]
    announcer.activate(:stdout)      if example.metadata[:announce_stdout]
    announcer.activate(:stderr)      if example.metadata[:announce_stderr]

    if example.metadata[:announce_output]
      announcer.activate(:stderr)
      announcer.activate(:stdout)
    end

    if example.metadata[:announce]
      announcer.activate(:stderr)
      announcer.activate(:stdout)
      announcer.activate(:environment)
      announcer.activate(:command)
      announcer.activate(:directory)
    end
  end
end
