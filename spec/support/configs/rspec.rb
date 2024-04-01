require "rspec/core"
require "aruba/api"

RSpec.configure do |config|
  config.filter_run focus: true

  config.run_all_when_everything_filtered = true

  config.example_status_persistence_file_path = "tmp/rspec-examples.txt"
  config.profile_examples = 10

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # FIXME: Right, so we always include Aruba::Api, and all the special matchers
  # only work when that's done (and also are not loaded unless that's done?)
  config.include Aruba::Api
  config.before { setup_aruba }
end
