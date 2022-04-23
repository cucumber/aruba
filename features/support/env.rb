$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)

# Has to be the first file required so that all other files show coverage information
require "simplecov" unless RUBY_PLATFORM.include?("java")

# Standard Library
require "fileutils"
require "pathname"

# Gems
require "aruba/cucumber"
require "aruba/config/jruby"
require "rspec/expectations"

Before do |test_case|
  command_name = "#{test_case.location.file}:#{test_case.location.line} # #{test_case.name}"

  # Used in simplecov_setup so that each scenario has a different name and
  # their coverage results are merged instead of overwriting each other as
  # 'Cucumber Features'
  ENV["SIMPLECOV_COMMAND_NAME"] = command_name.to_s

  simplecov_setup_pathname =
    Pathname.new(__FILE__).expand_path.parent.join("simplecov_setup")

  # set environment variable so child processes will merge their coverage data
  # with parent process's coverage data.
  ENV["RUBYOPT"] = "-r#{simplecov_setup_pathname} #{ENV['RUBYOPT']}"
end
