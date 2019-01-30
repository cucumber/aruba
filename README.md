[![Gem Version](https://badge.fury.io/rb/aruba.svg)](http://badge.fury.io/rb/aruba)
[![Code Climate](https://codeclimate.com/github/cucumber/aruba.svg)](https://codeclimate.com/github/cucumber/aruba)
[![Join the chat at https://gitter.im/cucumber/aruba](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/cucumber/aruba?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Build status:

Linux / OS X  | Windows
------------- | -------------
[![Build Status](https://travis-ci.org/cucumber/aruba.svg?branch=master)](https://travis-ci.org/cucumber/aruba) | [![Build status](https://ci.appveyor.com/api/projects/status/jfo2tkqhnrqqcivl?svg=true)](https://ci.appveyor.com/project/cucumberbdd/aruba/branch/master)

`aruba` is an extension for popular TDD and BDD frameworks like "Cucumber", "RSpec" and "Minitest" to make testing of commandline applications meaningful, easy and fun.

Features at a glance:

* Test any command line application, implemented in any [programming
  language](features/getting_started/supported_programming_languages.feature) -
  e.g. Bash, Python, Ruby, Java, ...
* Manipulate the file system and the process environment
* Automatically reset state of file system and process environment between tests

## Install

Add this line to your application's `Gemfile`:

    gem 'aruba'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aruba

### Release Policy

We try to be compliant to [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html).

### Supported ruby versions

For an up to date list of all supported ruby versions, please see our [`.travis.yml`](https://github.com/cucumber/aruba/blob/master/.travis.yml). We only test against the latest version of a version branch - most times.

## Usage

Please also see this
[feature test](https://github.com/cucumber/aruba/blob/master/features/getting_started/supported_testing_frameworks.feature)
for the most up to date documentation.

### Initialize your project with "aruba"

There's an initializer to make it easier for you to getting started. If you
prefer to setup `aruba` yourself, please move on to the next section.

1. Go to your project's directory

2. Make sure, it's under version control and all changes are committed to your
   version control repository

3. Run one of the following commands depending on the tools you use to test your project.

   This assumes, that you use either `rspec`, `cucumber-ruby` or `minitest` to
   write the tests for your project. Besides that, your tool can be implemented
   in any programming language you like.

   ~~~bash
   aruba init --test-framework rspec
   aruba init --test-framework cucumber
   aruba init --test-framework minitest
   ~~~

### Cucumber

1. Create a file named "features/support/env.rb" with:

   ~~~ruby
   require 'aruba/cucumber'
   ~~~

2. Create a file named "features/use_aruba_with_cucumber.feature" with:

   ~~~ruby
   Feature: Cucumber
     Scenario: First Run
       Given a file named "file.txt" with:
       """
       Hello World
       """
       Then the file "file.txt" should contain:
       """
       Hello World
       """
   ~~~

3. Run `cucumber`

### RSpec

1. Create a file named "spec/support/aruba.rb" with:

   ~~~ruby
   require 'aruba/rspec'
   ~~~

2. Create a file named "spec/spec_helper.rb" with:

   ~~~ruby
   $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

   if RUBY_VERSION < '1.9.3'
     ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require File.join(File.dirname(f), File.basename(f, '.rb')) }
   else
     ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
   end
   ~~~

3. Create a file named named "spec/use_aruba_with_rspec_spec.rb" with:

   ~~~ruby
   require 'spec_helper'

   RSpec.describe 'First Run', :type => :aruba do
     let(:file) { 'file.txt' }
     let(:content) { 'Hello World' }

     before(:each) { write_file file, content }

     it { expect(read(file)).to eq [content] }
   end
   ~~~

4. Run `rspec`

### Minitest

1. Add a file named "test/support/aruba.rb" with:

   ~~~ ruby
   require 'aruba/api'
   ~~~

2. Add a file named "test/test_helper.rb" with:

   ~~~ruby
   $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

   if RUBY_VERSION < '1.9.3'
     ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require File.join(File.dirname(f), File.basename(f, '.rb')) }
   else
     ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
   end
   ~~~

3. Add a file named "test/use_aruba_with_minitest.rb" with:

   ~~~ruby
   $LOAD_PATH.unshift File.expand_path('../test', __FILE__)

   require 'test_helper'
   require 'minitest/autorun'

   class FirstRun < Minitest::Test
     include Aruba::Api

     def setup
       aruba_setup
     end

     def getting_started_with_aruba
       file = 'file.txt'
       content = 'Hello World' 

       write_file file, content
       read(file).must_equal [content]
     end
   end
   ~~~

4. Run your tests

   `ruby -Ilib:test test/use_aruba_with_minitest.rb`

## Documentation

### User Documentation

If you're interested in our steps and API, please browse our [feature
files](https://github.com/cucumber/aruba/tree/master/features). You can find a
lot of examples there. A good starting point are [Getting
Started](https://github.com/cucumber/aruba/tree/master/features/getting_started)
and [Step
Overview](https://github.com/cucumber/aruba/blob/master/features/steps/overview.feature).
A more or less full list of our steps can be found
[here](https://github.com/cucumber/aruba/tree/master/features/steps). Our API
is documentated
[here](https://github.com/cucumber/aruba/tree/master/features/api) and some
more information about how to configure `aruba`, can be found
[here](https://github.com/cucumber/aruba/tree/master/features/configuration).
The "RSpec" matchers provided by `aruba`, are documented
[here](https://github.com/cucumber/aruba/tree/master/features/matchers).

You can find our documentation on
[Relish](http://www.relishapp.com/cucumber/aruba/docs) as well. Unfortunately
"Relish" does not like the way we structered our feature tests. So this
documentation found there may be not complete.

### Developer Documentation

`aruba` provides a wonderful API to be used in your tests:

* Creating files/directories
* Deleting files/directories
* Checking file size
* Checking file existence/absence
* ...

A full documentation of the API can be found
[here](http://www.rubydoc.info/github/cucumber/aruba/master/frames).

## Contributing

Please see the [CONTRIBUTING](CONTRIBUTING.md) file.

## Copyright

Copyright (c) 2010-2016 Aslak Hellesøy et al. See [MIT License](LICENSE) for details.
