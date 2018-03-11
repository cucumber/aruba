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
    elsif RUBY_VERSION > '1.9'
      gem 'debugger', '~> 1.6.8'
      gem 'pry-debugger', '~> 0.2.3'
    end
  end

  if RUBY_VERSION < '2'
    gem 'pry-doc', '~> 0.8.0'
  else
    gem 'pry-doc', '~> 0.13.1'
  end
end

group :development, :test do
  # we use this to demonstrate interactive debugging within our feature tests
  if RUBY_VERSION >= '2'
    gem 'pry', '~> 0.11.2'
  else
    gem 'pry', '~> 0.9.12'
  end

  # Run development tasks
  gem 'rake', '>= 10.0', '< 13.0'

  if RUBY_VERSION >= '2.0.0'
    # Lint travis yaml
    gem 'travis-yaml'

    # Reporting
    gem 'bcat', '~> 0.6.2'
    gem 'kramdown', '~> 1.7.0'
  end

  # Code Coverage
  gem 'simplecov', '~> 0.10'

  # Test api
  gem 'rspec', '~> 3.4'
  gem 'fuubar', '~> 2.0'

  # using platform for this make bundler complain about the same gem given
  # twice
  if RUBY_VERSION < '1.9.3'
    gem 'cucumber', '~> 1.3.20'
  else
    gem 'cucumber', '~> 2.0'
  end

  if RUBY_VERSION < '1.9.2'
    gem 'contracts', '~> 0.15.0'
  else
    gem 'contracts', '~> 0.16.0'
  end

  if RUBY_VERSION >= '1.9.3'
    # Make aruba compliant to ruby community guide
    gem 'rubocop', '~> 0.32', '< 0.41.1'
  end

  if RUBY_VERSION >= '1.9.3'
    gem 'cucumber-pro', '~> 0.0'
  end

  # License compliance
  if RUBY_VERSION >= '2.3'
    gem 'license_finder', '~> 5.0.3'
  elsif RUBY_VERSION >= '1.9.3'
    gem 'license_finder', '~> 2.0.4'
  end

  gem 'minitest', '~> 5.8'
end
