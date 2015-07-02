require 'rspec/core'
require 'aruba/api'

RSpec.configure do |config|
  config.filter_run :focus => true

  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Aruba::Api
  config.before(:each) { setup_aruba }
end
