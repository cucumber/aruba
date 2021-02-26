source "https://rubygems.org"

# Use dependencies from gemspec
gemspec

group :development do
  if RUBY_VERSION >= "2.4.0"
    gem "license_finder", "~> 6.0"
    gem "rake-manifest", "~> 0.2.0"
    gem "simplecov", [">= 0.18.0", "< 0.22.0"]
  end
end

# Load local Gemfile
if File.file? File.expand_path("Gemfile.local", __dir__)
  load File.expand_path("Gemfile.local", __dir__)
end

unless RUBY_PLATFORM.include?("java")
  gem "byebug", "~> 11.0"
  gem "pry-byebug", "~> 3.4"
end
