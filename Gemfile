source "https://rubygems.org"

# Use dependencies from gemspec
gemspec

# Load local Gemfile
if File.file? File.expand_path("Gemfile.local", __dir__)
  load File.expand_path("Gemfile.local", __dir__)
end

gem "byebug", "~> 11.0", platform: :mri
gem "pry-byebug", "~> 3.4", platform: :mri
