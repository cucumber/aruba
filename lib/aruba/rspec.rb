require 'rspec/core'

require 'aruba'
require 'aruba/api'
require 'aruba/reporting'

RSpec.configure do |config|
  config.include Aruba::Api, type: :aruba

  config.before :each do
    next unless self.class.include? Aruba::Api

    restore_env
    clean_current_directory
  end

  config.before :each do |example|
    next unless self.class.include? Aruba::Api

    example.metadata.each { |k, v| aruba.config.set_if_option(k, v) }
  end

  # config.before do
  #   next unless self.class.include?(Aruba::Api)

  #   current_example = context.example

  #   announcer.activate(:environment) if current_example.metadata[:announce_env]
  #   announcer.activate(:command)     if current_example.metadata[:announce_cmd]
  #   announcer.activate(:directory)     if current_example.metadata[:announce_dir]
  #   announcer.activate(:stdout)      if current_example.metadata[:announce_stdout]
  #   announcer.activate(:stderr)      if current_example.metadata[:announce_stderr]
  # end
end
