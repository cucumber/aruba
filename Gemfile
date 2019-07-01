source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

# Debug aruba
group :debug do
  if RUBY_VERSION >= '2.2'
    gem 'byebug', '~> 10.0'
  elsif RUBY_VERSION >= '2.0'
    gem 'byebug', '~> 9.0'
  end

  gem 'pry-byebug', '~> 3.4'
  gem 'pry-doc', '~> 1.0.0'
end

# Tools to run during development
group :development do
  # License compliance
  if RUBY_VERSION >= '2.3'
    gem 'license_finder', '~> 5.0'
  elsif RUBY_VERSION >= '2.0.0'
    gem 'license_finder', '~> 2.0.4'
  end
end

group :development, :test do
  gem 'pry', '~> 0.12.2'
  gem 'yard', '~> 0.9.11'
  gem 'simplecov', '~> 0.10' unless RUBY_PLATFORM.include?('java')
  gem 'rspec', '~> 3.4'
  gem 'childprocess', '~> 1.0.1'
  gem 'contracts', '~> 0.16.0'
end
