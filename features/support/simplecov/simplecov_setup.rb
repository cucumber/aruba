# @note this file is loaded in env.rb to setup simplecov using RUBYOPTs for
# child processes and @in-process
unless RUBY_PLATFORM.include?("java")
  require "simplecov"
  root = File.expand_path("../../..", __dir__)
  command_name = ENV["SIMPLECOV_COMMAND_NAME"] || "Cucumber Features"
  SimpleCov.command_name(command_name)
  SimpleCov.root(root)

  # Run simplecov by default
  SimpleCov.start unless ENV.key? "ARUBA_NO_COVERAGE"

  module SimpleCov
    module Formatter
      class HTMLFormatter
        def format(result)
          Dir[File.join(File.dirname(__FILE__), "../public/*")].each do |path|
            FileUtils.cp_r(path, asset_output_path)
          end

          File.open(File.join(output_path, "index.html"), "wb") do |file|
            file.puts template("layout").result(binding)
          end
          File.open(File.join(output_path, "summary.txt"), "w") do |file|
            file.puts output_message(result)
          end
        end
      end
    end
  end
end
