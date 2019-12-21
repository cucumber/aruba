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
    gem 'pry-doc', '~> 1.0.0'
  end
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
  else
    gem 'pry', '~> 0.9.12'
  end

  # Run development and test tasks
  if RUBY_VERSION >= '2.0.0'
    gem 'rake', '~> 12.3'
  elsif RUBY_VERSION >= '1.9.3'
    gem 'rake', '~> 12.2.0'
  else
    gem 'rake', '~> 10.5.0'
  end

  if RUBY_VERSION >= '2.0.0'
    # Lint travis yaml
    gem 'travis-yaml'

    # Reporting
    gem 'bcat', '~> 0.6.2'
  end

  # YARD documentation
  if RUBY_VERSION >= '2.3.0'
    gem 'yard', '~> 0.9.11'
    gem 'kramdown', '~> 2.1'
  elsif RUBY_VERSION >= '2.0.0'
    gem 'yard', '~> 0.9.11'
    gem 'kramdown', '~> 1.7.0'
  end

  # Code Coverage
  unless RUBY_PLATFORM.include?('java')
    gem 'simplecov', '~> 0.10' 
    if RUBY_VERSION < '2.0.0'
      gem 'json', '< 2.3.0'
    end
  end


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
    gem 'childprocess', '~> 0.6.3'
  elsif RUBY_VERSION < '2.3.0'
    gem 'childprocess', '~> 1.0.1'
  else
    gem 'childprocess', ['>= 2.0', '< 4.0']
  end

  if RUBY_VERSION < '1.9.2'
    gem 'contracts', '~> 0.15.0'
  else
    gem 'contracts', '~> 0.16.0'
  end

  if RUBY_VERSION >= '2.0.0'
    # Make aruba compliant to ruby community guide
    gem 'rubocop', '~> 0.32', '< 0.41.1'
  end

  if RUBY_VERSION < '2.0.0'
    gem 'ffi', '< 1.11.0'
  end

  if RUBY_VERSION < '1.9.3'
    gem 'minitest', '~> 5.8.0'
  else
    gem 'minitest', '~> 5.8'
  end
end
