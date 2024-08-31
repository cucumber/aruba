# frozen_string_literal: true

$LOAD_PATH << File.expand_path('../lib', __dir__)

unless RUBY_PLATFORM.include?('java')
  require 'simplecov'
  SimpleCov.command_name 'RSpec'

  # Run simplecov by default
  SimpleCov.start unless ENV.key? 'ARUBA_NO_COVERAGE'
end

# Loading support files
Dir.glob(File.expand_path('support/*.rb', __dir__)).each { |f| require_relative f }
Dir.glob(File.expand_path('support/**/*.rb', __dir__)).each { |f| require_relative f }
