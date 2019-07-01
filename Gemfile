source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

group :debug, :development, :test do
  unless RUBY_PLATFORM.include?('java')
    gem 'simplecov', '~> 0.10'
    gem 'byebug', ['>= 9.0', '< 11.0']
    gem 'pry-byebug', '~> 3.4'
  end
end
