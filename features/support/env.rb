$LOAD_PATH.unshift File.expand_path('../../lib', __dir__)

# Has to be the first file required so that all other files show coverage information
require 'simplecov'

# Standard Library
require 'fileutils'
require 'pathname'

# Gems
require 'aruba/cucumber'
require 'rspec/expectations'

Before do |scenario|
  unless scenario.respond_to?(:feature) && scenario.respond_to?(:name)
    raise TypeError, "Don't know how to extract command name from #{scenario.class}"
  end

  command_name = "#{scenario.feature.name} #{scenario.name}"

  # Used in simplecov_setup so that each scenario has a different name and their coverage results are merged instead
  # of overwriting each other as 'Cucumber Features'
  ENV['SIMPLECOV_COMMAND_NAME'] = command_name.to_s

  simplecov_setup_pathname = Pathname.new(__FILE__).expand_path.parent.join('simplecov_setup')

  # set environment variable so child processes will merge their coverage data with parent process's coverage data.
  ENV['RUBYOPT'] = "-r#{simplecov_setup_pathname} #{ENV['RUBYOPT']}"
end
