# frozen_string_literal: true

# @note this file is loaded in env.rb to setup simplecov using RUBYOPTs for
# child processes and @in-process
unless RUBY_PLATFORM.include?("java")
  require "simplecov"
  root = File.expand_path("../..", __dir__)
  command_name = ENV["SIMPLECOV_COMMAND_NAME"] || "Cucumber Features"
  SimpleCov.command_name(command_name)
  SimpleCov.root(root)

  # Run simplecov by default
  SimpleCov.start unless ENV.key? "ARUBA_NO_COVERAGE"
end
