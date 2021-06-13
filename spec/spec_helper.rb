$LOAD_PATH << ::File.expand_path("../lib", __dir__)

unless RUBY_PLATFORM.include?("java")
  require "simplecov"
  SimpleCov.command_name "rspec"
  SimpleCov.start
end

# Loading support files
Dir.glob(::File.expand_path("support/*.rb", __dir__)).each { |f| require_relative f }
Dir.glob(::File.expand_path("support/**/*.rb", __dir__)).each { |f| require_relative f }
