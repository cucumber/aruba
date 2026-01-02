# frozen_string_literal: true

source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

# Needed on Ruby 4.0, since win32ole is now a gem
gem 'win32ole', platform: :windows

# Load local Gemfile
if File.file? File.expand_path('Gemfile.local', __dir__)
  load File.expand_path('Gemfile.local', __dir__)
end
