$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)

# Has to be the first file required so that all other files show coverage information
require 'simplecov'

# Standard Library
require 'fileutils'
require 'pathname'

# Gems
require 'aruba/cucumber'
require 'rspec/expectations'

Before do |scenario|
  command_name = if scenario.respond_to?(:feature) && scenario.respond_to?(:name)
                   "#{scenario.feature.name} #{scenario.name}"
                 else
                   raise TypeError.new("Don't know how to extract command name from #{scenario.class}")
                 end

  # Used in simplecov_setup so that each scenario has a different name and their coverage results are merged instead
  # of overwriting each other as 'Cucumber Features'
  ENV['SIMPLECOV_COMMAND_NAME'] = command_name.to_s

  simplecov_setup_pathname = Pathname.new(__FILE__).expand_path.parent.join('simplecov_setup')

  # set environment variable so child processes will merge their coverage data with parent process's coverage data.
  ENV['RUBYOPT'] = if RUBY_VERSION < '1.9'
                     "-r rubygems -r#{simplecov_setup_pathname} #{ENV['RUBYOPT']}"
                   else
                     "-r#{simplecov_setup_pathname} #{ENV['RUBYOPT']}"
                   end
end
