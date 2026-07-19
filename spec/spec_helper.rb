# frozen_string_literal: true

$LOAD_PATH << File.expand_path('../lib', __dir__)

unless RUBY_PLATFORM.include?('java')
  require 'simplecov'
  SimpleCov.command_name 'RSpec'

  # Run simplecov by default
  SimpleCov.start unless ENV.key? 'ARUBA_NO_COVERAGE'
end

require 'rspec/core'
require 'aruba/rspec'
require 'aruba/config/jruby'

Aruba.configure do |config|
  config.activate_announcer_on_command_failure = %i[stderr stdout command]
end

RSpec.configure do |config|
  config.filter_run_when_matching :focus

  config.example_status_persistence_file_path = 'tmp/rspec-examples.txt'
  config.profile_examples = 10

  config.expect_with :rspec

  config.include Aruba::Api
  config.before { setup_aruba }
end

# Load support files
require_relative 'support/shared_examples/configuration'
require_relative 'support/shared_contexts/aruba'
