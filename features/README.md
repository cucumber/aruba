[![GitHub stars](https://img.shields.io/github/stars/cucumber/aruba.svg)](https://github.com/cucumber/aruba/stargazers)
[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/cucumber/aruba/master/LICENSE)
[![Gem Version](https://badge.fury.io/rb/aruba.svg)](http://badge.fury.io/rb/aruba)
[![Code Climate](https://codeclimate.com/github/cucumber/aruba.svg)](https://codeclimate.com/github/cucumber/aruba)
[![Support](https://img.shields.io/badge/cucumber-support-orange.svg)](https://cucumber.io/support)

**This is the [latest](https://github.com/cucumber/aruba/blob/master/features/README.md)
version of our README.md ([master](https://github.com/cucumber/aruba/tree/master) branch).**

Aruba is an extension for popular TDD and BDD frameworks like Cucumber, RSpec
and Minitest to make testing of command line applications meaningful, easy and
fun.

Your benefits:

* Test any command line application implemented in any programming language &ndash;
  e.g. Bash, Python, Ruby, Java, ...
* Manipulate the file system and the process environment with helpers working
  similarly to tools you may know from your shell
* No worries about leaking state: The file system and the process environment
  will be reset between tests
* Support by a helpful and welcoming community &ndash; see our
  [Code of Conduct](https://github.com/cucumber/cucumber/blob/master/CODE_OF_CONDUCT.md)
* The [documentation](https://app.cucumber.pro/projects/aruba) is our contract
  with you. You can expect Aruba to work as documented

Our Vision:

* Help our users to build better command line applications written in any
  programming language
* Make creating documentation for command line applications simple and fun
* Support the cucumber community in its effort to create a specification for
  all official cucumber implementations

Our Focus:
* Test the user-interaction with the commands at runtime &ndash; this excludes
  the process of installation/deployment of commands like installing Rubygems
  with `gem install <your-gem>`.

# Install

Add this line to your application's `Gemfile`:

```ruby
gem 'aruba'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install aruba
```

# Usage

**Note:** Please also see this
[feature test](https://app.cucumber.pro/projects/Aruba/documents/master/features/01_getting_started_with_aruba/supported_testing_frameworks.feature)
for the most up to date documentation.

## Getting started

1. Clone the "Getting Started" application and make the cloned repository your current working directory

   ```bash
   git clone https://github.com/cucumber/aruba-getting-started.git
   cd aruba-getting-started
   ```

2. Install the required dependencies

   ```bash
   bundle install
   ```

### Cucumber

1. Create a file named `features/support/env.rb` with:

   ```ruby
   require 'aruba/cucumber'
   ```

2. Create a file named `features/use_aruba_with_cucumber.feature` with:

   ```ruby
   Feature: Cucumber
     Scenario: First Run
       Given a file named "file.txt" with:
       """
       Hello, Aruba!
       """
       When I run `aruba-test-cli file.txt` 
       Then the file "file.txt" should contain:
       """
       Hello, Aruba!
       """
   ```

3. Run `cucumber`

   ```bash
   bundle exec cucumber
   ```

### RSpec

1. Add the following line to the `spec/spec_helper.rb` file.

   ```ruby
   require 'aruba/rspec'
   ```

2. Create a file named `spec/use_aruba_with_rspec_spec.rb` with:

   ```ruby
   require 'spec_helper'

   RSpec.describe 'First Run', :type => :aruba do
     let(:file) { 'file.txt' }
     let(:content) { 'Hello, Aruba!' }

     before { write_file file, content }
     before { run_command('aruba-test-cli file.txt') }

     # Full string
     it { expect(last_command_started).to have_output content }

     # Substring
     it { expect(last_command_started).to have_output(/Hello/) }
   end
   ```

3. Run `rspec`

   ```bash
   bundle exec rspec
   ```

### Minitest

1. Add the following line to the `test/test_helper.rb` file.

   ```ruby
   require 'aruba/api'
   ```

3. Add a file named `test/use_aruba_with_minitest.rb` with:

   ```ruby
   require 'test_helper'
   require 'minitest/autorun'

   class FirstRun < Minitest::Test
     include Aruba::Api

     def setup
       setup_aruba
     end

     def test_getting_started_with_aruba
       file = 'file.txt'
       content = 'Hello, Aruba!'

       write_file file, content

       run_command_and_stop 'aruba-test-cli file.txt'
       assert_equal last_command_started.output.chomp, content
     end
   end
   ```

4. Run your tests

   ```bash
   bundle exec ruby -I lib:test test/use_aruba_with_minitest.rb
   ```

## Development

### Api Documentation

A full documentation of the API can be found
[here](http://www.rubydoc.info/github/cucumber/aruba/master/frames).

### Code branches

Development for the upcoming 1.0.0 release takes place in the `master` branch.
Maintenance of the current 0.14.x releases takes place in the `0-14-stable`
branch. After the 1.0.0 release, development will take place in the `master`
branch as much as possible. Stable branches will not be created until
absolutely necessary.

# Initialize an existing project

There's an initializer to make it easier for you to get started.

1. Go to your project's directory

2. Make sure it's under version control and all changes are committed to your
   version control repository

3. Run one of the following commands depending on the tools you use to test your project.

   This assumes, that you use either `rspec`, `cucumber-ruby` or `minitest` to
   write the tests for your project. Besides that, your tool can be implemented
   in any programming language you like.

   ```bash
   aruba init --test-framework rspec
   aruba init --test-framework cucumber
   aruba init --test-framework minitest
   ```

# Copyright

Copyright (c) 2010-2020 Aslak Hellesøy et al. See [MIT License](LICENSE) for details.
