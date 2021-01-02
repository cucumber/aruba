require 'rspec/core'
require 'aruba/api'

RSpec.configure do |config|
  config.filter_run focus: true

  config.run_all_when_everything_filtered = true

  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.profile_examples = 10

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Aruba::Api
  config.before { setup_aruba }
end
