source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

# Load local Gemfile
load File.expand_path('../Gemfile.local', __FILE__) if File.file? File.expand_path('../Gemfile.local', __FILE__)

# Debug aruba
group :debug do
  unless RUBY_PLATFORM.include?('java')
    if RUBY_VERSION >= '2.2'
      gem 'byebug', '~> 10.0'
      gem 'pry-byebug', '~> 3.4'
    elsif RUBY_VERSION >= '2'
      gem 'byebug', '~> 9.0'
      gem 'pry-byebug', '~> 3.4'
    else
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
  # Needed for lint:yard:junk task
  if RUBY_VERSION >= '2.3.0'
    gem 'yard-junk', '~> 0'
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
  else
    gem 'rake', '~> 12.2.0'
  end

  if RUBY_VERSION >= '2.0.0'
    # Lint travis yaml
    gem 'travis-yaml'

    # Reporting
    gem 'kramdown', '~> 1.14'
  end

  # Code Coverage
  gem 'single_cov'

  # API docs generation
  gem 'yard', '~>0.9.9'

  # Test api
  gem 'rspec', '~> 3.4'
  gem 'fuubar', '~> 2.2'

  if RUBY_VERSION >= '2.0.0'
    # Make aruba compliant to ruby community guide
    gem 'rubocop', '~> 0.50.0'
  end

  # gem 'cucumber-pro', '~> 0.0'

  # License compliance
  if RUBY_VERSION >= '2.3'
    gem 'license_finder', '~> 5.0'
  end

  # Upload documentation
  # gem 'relish', '~> 0.7.1'

  gem 'minitest', '~> 5.8'

  gem 'json', '~>2.1'
end
