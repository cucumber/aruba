# frozen_string_literal: true

require 'rspec/core'
require 'aruba/api'

RSpec.configure do |config|
  config.filter_run_when_matching :focus

  config.example_status_persistence_file_path = 'tmp/rspec-examples.txt'
  config.profile_examples = 10

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Aruba::Api
  config.before { setup_aruba }
end
