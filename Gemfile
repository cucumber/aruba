source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

# Load local Gemfile
load File.expand_path('../Gemfile.local', __FILE__) if File.file? File.expand_path('../Gemfile.local', __FILE__)

# Debug aruba
group :debug do
  unless RUBY_PLATFORM.include?('java')
    gem 'byebug', '~> 11.0'
    gem 'pry-byebug', '~> 3.4'
  end
end
