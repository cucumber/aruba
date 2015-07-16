source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

# Debug aruba
group :debug do
  gem 'pry', '~> 0.10.1'

  if RUBY_VERSION >= '2'
    gem 'byebug', '~> 4.0.5'
    gem 'pry-byebug', '~> 3.1.0'
  end

  if RUBY_VERSION < '2'
    gem 'debugger', '~> 1.6.8'
    gem 'pry-debugger', '~> 0.2.3'
  end

  if RUBY_VERSION >= '1.9.3'
    gem 'pry-stack_explorer', '~> 0.4.9'
  end

  gem 'pry-doc', '~> 0.8.0'
end

group :development, :test do
  # Run development tasks
  gem 'rake', '~> 10.4.2'

  if RUBY_VERSION >= '1.9.3'
    # Reporting
    gem 'bcat', '~> 0.6.2'
    gem 'kramdown', '~> 1.7.0'
  end

  # Code Coverage
  gem 'simplecov', '~> 0.10'

  # Test api
  gem 'rspec', '~> 3.3.0'
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
    gem 'rubocop', '~> 0.32.0'
  end

  if RUBY_VERSION >= '1.9.3'
    gem 'cucumber-pro', '~> 0.0'
  end

  if RUBY_VERSION >= '1.9.3'
    # License compliance
    gem 'license_finder', '~> 2.0.4'
  end

  if RUBY_VERSION >= '1.9.3'
    # Upload documentation
    gem 'relish', '~> 0.7.1'
  end
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius-developer_tools'
end
