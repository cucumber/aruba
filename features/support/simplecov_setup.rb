# frozen_string_literal: true

# @note this file is loaded in env.rb to setup simplecov using RUBYOPTs for
# child processes and @in-process
#
# Current implementation slows down things immensely:
#
# On main:
# bin/cucumber --format progress  192.97s user 34.46s system 79% cpu 4:47.10 total
#
# On fix-simplecov-integration: with SimpleFormatter
# bin/cucumber --format progress  581.96s user 75.12s system 91% cpu 12:00.38 total
#
# On fix-simplecov-integration: with DumbFormatter
# bin/cucumber --format progress  732.04s user 105.59s system 92% cpu 15:05.49 total
#
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
