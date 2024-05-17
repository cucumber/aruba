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
      # @note this is a monkey patch to suppress console output generated by
      # the Simplecov HTML formatter.
      #
      # The Simplecov HTML formatter, which is the default, writes a message to
      # the console after it has stored coverage information the `coverage`
      # directory. There is no built in way to suppress this message. See
      # simplecov-ruby/simplecov-html#116 and
      # https://github.com/simplecov-ruby/simplecov-html/blob/v0.12.3/lib/simplecov-html.rb#L23..L32.
      #
      # The console output generated by the default formatter causes failures
      # for Aruba tests that are expecting exact command output.
      #
      # The approach employed here is to monkey patch the method so that it
      # still generates the same message, but instead of writing to the console,
      # it writes to a file in the `coverage` directory named `summary.txt`.
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
