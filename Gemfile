source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

# Load local Gemfile
if File.file? File.expand_path('Gemfile.local', __dir__)
  load File.expand_path('Gemfile.local', __dir__)
end

unless RUBY_PLATFORM.include?('java')
  gem 'byebug', '~> 11.0'
  gem 'pry-byebug', '~> 3.4'
end
