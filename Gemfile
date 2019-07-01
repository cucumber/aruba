source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

# Debug aruba
group :debug do
  unless RUBY_PLATFORM.include?('java')
    if RUBY_VERSION >= '2.2'
      gem 'byebug', '~> 10.0'
      gem 'pry-byebug', '~> 3.4'
    elsif RUBY_VERSION >= '2'
      gem 'byebug', '~> 9.0'
      gem 'pry-byebug', '~> 3.4'
    end
  end

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
  # we use this to demonstrate interactive debugging within our feature tests
  if RUBY_VERSION >= '2'
    gem 'pry', '~> 0.12.2'
  end

  # Run development and test tasks
  if RUBY_VERSION >= '2.0.0'
    gem 'rake', '~> 12.3'
  end

  # Lint travis yaml
  gem 'travis-yaml'

  # Reporting
  gem 'bcat', '~> 0.6.2'

  # YARD documentation
  if RUBY_VERSION >= '2.3.0'
    gem 'yard', '~> 0.9.11'
    gem 'kramdown', '~> 2.1'
  elsif RUBY_VERSION >= '2.0.0'
    gem 'yard', '~> 0.9.11'
    gem 'kramdown', '~> 1.7.0'
  end

  # Code Coverage
  gem 'simplecov', '~> 0.10' unless RUBY_PLATFORM.include?('java')

  # Test api
  gem 'rspec', '~> 3.4'
  gem 'fuubar', '~> 2.0'

  gem 'childprocess', '~> 1.0.1'
  gem 'contracts', '~> 0.16.0'

  gem 'rubocop', '~> 0.32', '< 0.41.1'

  if RUBY_VERSION >= '1.9.3'
    gem 'cucumber-pro', '~> 0.0'
  end

  gem 'minitest', '~> 5.8'
end
