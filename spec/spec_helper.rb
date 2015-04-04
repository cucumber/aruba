require 'rspec/core'
require 'aruba/api'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Aruba::Api
  config.before(:each) { clean_current_dir }
end

Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
