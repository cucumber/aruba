# frozen_string_literal: true

# @note this file is loaded in env.rb to setup simplecov using RUBYOPTs for
# child processes and @in-process
unless RUBY_PLATFORM.include?("java")
  require "simplecov"
  root = File.expand_path("../..", __dir__)
  SimpleCov.root(root)

  if (command_name = ENV["SIMPLECOV_COMMAND_NAME"])
    SimpleCov.command_name(command_name)
    SimpleCov.formatter SimpleCov::Formatter::SimpleFormatter
  else
    SimpleCov.command_name "Cucumber Features"
  end

  # Run simplecov by default
  SimpleCov.start unless ENV.key? "ARUBA_NO_COVERAGE"
end
