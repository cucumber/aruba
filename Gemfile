source 'https://rubygems.org'

# Use dependencies from gemspec
gemspec

# Load local Gemfile
load File.expand_path('../Gemfile.local', __FILE__) if File.file? File.expand_path('../Gemfile.local', __FILE__)

# Debug aruba
group :debug do
  unless RUBY_PLATFORM.include?('java')
    if RUBY_VERSION >= '2.3.0'
      gem 'byebug', '~> 11.0'
    else
      gem 'byebug', '~> 10.0'
    end

    gem 'pry-byebug', '~> 3.4'
  end

  gem 'pry-doc', '~> 1.0.0'
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
  gem 'pry', '~> 0.12.2'

  # Run development and test tasks
  gem 'rake', '~> 12.3'

  # Lint travis yaml
  gem 'travis-yaml'

  # Code Coverage
  gem 'simplecov', '~> 0.10'

  # API docs generation
  gem 'yard', '~>0.9.9'

  # Test api
  gem 'fuubar', '~> 2.2'
  gem 'rspec', '~> 3.4'

  # Make aruba compliant to ruby community guide
  gem 'rubocop', '~> 0.69.0'
  gem 'rubocop-performance', '~> 1.1'

  # License compliance
  if RUBY_VERSION >= '2.3'
    gem 'license_finder', '~> 5.0'
  end

  gem 'minitest', '~> 5.8'

  gem 'json', '~> 2.1'
end
