**This is the [latest](https://github.com/cucumber/aruba/blob/master/features/README.md) version of our README.md. If you want to see the one of the last released version of "aruba", please have a look at this [one](https://github.com/cucumber/aruba/blob/still/features/README.md).**

`aruba` is an extension for popular TDD and BDD frameworks like "Cucumber", "RSpec" and "Minitest" to make testing of commandline applications meaningful, easy and fun.

Your benefits:

* Test any command line application implemented in any [programming
  language](https://github.com/cucumber/aruba/tree/master/features/getting_started/supported_programming_languages.feature) -
  e.g. Bash, Python, Ruby, Java, ...
* Manipulate the file system and the process environment with helpers working similar like tools you may know from your shell
* No worries about leaking state: The file system and the process environment will be reset between tests
* Support by a helpful and welcoming community &ndash; see our [Code of Conduct](https://github.com/cucumber/cucumber/blob/master/CODE_OF_CONDUCT.md)
* The [documentation](https://github.com/cucumber/aruba/tree/master/features/) is our contract with you. You can expect `aruba` to work as documented

Our Vision:

* Help our users to build better command line applications written in any programming language
* Make creating documentation for command line simple and fun
* Support the cucumber community in its effort to create a specification for all official cucumber implementations

Our Focus:
* Test the user-interaction with the commands at runtime &ndash; this excludes the process of installation/deployment of commands like installing Rubygems with `gem install <your-gem>`.

## Install

Add this line to your application's `Gemfile`:

~~~
gem 'aruba'
~~~

And then execute:

~~~
$ bundle
~~~

Or install it yourself as:

~~~
$ gem install aruba
~~~

## Usage

Please also see this
[feature test](https://github.com/cucumber/aruba/tree/master/features/getting_started/supported_testing_frameworks.feature)
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
       When 
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

   ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
   ~~~

3. Create a file named "spec/use_aruba_with_rspec_spec.rb" with:

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

   ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
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

A full documentation of the API can be found
[here](http://www.rubydoc.info/github/cucumber/aruba/master/frames).

## Copyright

Copyright (c) 2010-2017 Aslak Hellesøy et al. See [MIT License](LICENSE) for details.
