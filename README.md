[![Gem Version](https://badge.fury.io/rb/aruba.svg)](http://badge.fury.io/rb/aruba)
[![Dependency Status](https://gemnasium.com/cucumber/aruba.svg)](https://gemnasium.com/cucumber/aruba)
[![Code Climate](https://codeclimate.com/github/cucumber/aruba.svg)](https://codeclimate.com/github/cucumber/aruba)
[![Join the chat at https://gitter.im/cucumber/aruba](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/cucumber/aruba?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Build status:

Linux / OS X  | Windows
------------- | -------------
[![Build Status](https://travis-ci.org/cucumber/aruba.svg)](http://travis-ci.org/cucumber/aruba) | [![Build status](https://ci.appveyor.com/api/projects/status/jfo2tkqhnrqqcivl?svg=true)](https://ci.appveyor.com/project/cucumberbdd/aruba/branch/master)

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

### Cucumber

To use `aruba` with cucumber, `require` the library in one of your ruby files
under `features/support` (e.g. `env.rb`)

```ruby
require 'aruba/cucumber'
```

You now have a bunch of step definitions that you can use in your features. Look at [`lib/aruba/cucumber.rb`](lib/aruba/cucumber.rb)
to see them all. Look at [`features/*.feature`](features/) for examples (which are also testing Aruba
itself).

### RSpec

Originally written for `cucumber`, `aruba` can be helpful in other contexts as
well. One might want to use it together with `rspec`.

1. Create a directory named `spec/support`
2. Create a file named `spec/support/aruba.rb` with:

  ```ruby
  require 'aruba/rspec'
  ```

3. Add the following to your `spec/spec_helper.rb`

  ```ruby
  Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
  ```

4. Add a type to your specs

  ```ruby
  RSpec.describe 'My feature', type: :aruba do
    # [...]
  end
  ```

### Minitest

TBD :-)

## Documentation

### User Documentation

If you're interested in our steps and API, please browser our [feature
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

Please see the `CONTRIBUTING.md`.

## Copyright

Copyright (c) 2010-2015 Aslak Hellesøy et al. See LICENSE for details.
