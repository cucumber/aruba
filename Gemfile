source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

# Debug aruba
group :debug do
  gem 'pry', '~> 0.10.1'

  platform :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx do
    gem 'byebug', '~> 4.0.5'
    gem 'pry-byebug', '~> 3.1.0'
  end

  platform :ruby_19 do
    gem 'debugger', '~> 1.6.8'
    gem 'pry-debugger', '~> 0.2.3'
  end

  platform :ruby_19, :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx do
    gem 'pry-stack_explorer', '~> 0.4.9'
  end

  gem 'pry-doc', '~> 0.8.0'
end

group :development, :test do
  # Run development tasks
  gem 'rake', '~> 10.4.2'

  platform :ruby_19, :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx do
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
  if RUBY_VERSION < '1.9'
    gem 'cucumber', '~> 1.3.20'
  else
    gem 'cucumber', '~> 2.0'
  end

  # Make aruba compliant to ruby community guide
  platform :ruby_19, :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx do
    gem 'rubocop', '~> 0.32.0'
  end

  platform :ruby_19, :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx do
    gem 'cucumber-pro', '~> 0.0'
  end

  platform :ruby_19, :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx do
    # License compliance
    gem 'license_finder', '~> 2.0.4'
  end

  platform :ruby_19, :ruby_20, :ruby_21, :ruby_22, :jruby, :rbx do
    # Upload documentation
    gem 'relish', '~> 0.7.1'
  end
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius-developer_tools'
end
