$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)

# Has to be the first file required so that all other files show coverage information
require_relative "simplecov/simplecov_setup" unless RUBY_PLATFORM.include?("java")

# Standard Library
require "fileutils"
require "pathname"
# Gems
require "aruba/cucumber"
require "aruba/config/jruby"
require "rspec/expectations"

Around do |test_case, block|
  command_name = "#{test_case.location.file}:#{test_case.location.line} # #{test_case.name}"

  # Used in simplecov_setup so that each scenario has a different name and
  # their coverage results are merged instead of overwriting each other as
  # 'Cucumber Features'
  set_environment_variable "SIMPLECOV_COMMAND_NAME", command_name.to_s

  simplecov_setup_pathname =
    Pathname.new(__FILE__).expand_path.parent.join("simplecov").to_s

  # set environment variable so child processes will merge their coverage data
  # with parent process's coverage data.
  prepend_environment_variable "RUBYOPT", "-I#{simplecov_setup_pathname} -rsimplecov_setup "

  with_environment do
    block.call
  end
end
