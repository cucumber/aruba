$LOAD_PATH << ::File.expand_path("../lib", __dir__)

unless RUBY_PLATFORM.include?("java")
  begin
    require "simplecov"
    SimpleCov.command_name "rspec"
    SimpleCov.start
  rescue LoadError
    # skip
  end
end

# Pull in all of the gems including those in the `test` group
require "bundler"
Bundler.require

# Loading support files
Dir.glob(::File.expand_path("support/*.rb", __dir__)).each { |f| require_relative f }
Dir.glob(::File.expand_path("support/**/*.rb", __dir__)).each { |f| require_relative f }
