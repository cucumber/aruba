source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

# Debug aruba
group :debug do
  if RUBY_VERSION >= '2' && !RUBY_PLATFORM.include?('java')
    gem 'byebug', '~> 4.0.5'
    gem 'pry-byebug', '~> 3.1.0'
  end

  if RUBY_VERSION < '2' && RUBY_VERSION > '1.9' && !RUBY_PLATFORM.include?('java')
    gem 'debugger', '~> 1.6.8'
    gem 'pry-debugger', '~> 0.2.3'
  end

  gem 'pry-doc', '~> 0.8.0'
end

group :development, :test do
  # we use this to demonstrate interactive debugging within our feature tests
  if RUBY_VERSION >= '2'
    gem 'pry', '~> 0.10.1'
  else
    gem 'pry', '~>0.9.12'
  end

  # Run development tasks
  gem 'rake', '~> 10.4.2'

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
  gem 'fuubar', '~> 2.0.0'

  # using platform for this make bundler complain about the same gem given
  # twice
  if RUBY_VERSION < '1.9.3'
    gem 'cucumber', '~> 1.3.20'
  else
    gem 'cucumber', '~> 2.0'
  end

  if RUBY_VERSION >= '1.9.3'
    # Make aruba compliant to ruby community guide
    gem 'rubocop', '~> 0.32', '< 0.41.1'
  end

  if RUBY_VERSION >= '1.9.3'
    gem 'cucumber-pro', '~> 0.0'
  end

  if RUBY_VERSION >= '1.9.3'
    # License compliance
    gem 'license_finder', '~> 2.0.4'
  end

  # if RUBY_VERSION >= '1.9.3'
  #   # Upload documentation
  #   gem 'relish', '~> 0.7.1'
  # end

  gem 'minitest', '~> 5.8.0'

  gem 'json', '~> 1.8'
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius-developer_tools'
end
