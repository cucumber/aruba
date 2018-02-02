[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/cucumber/aruba/master/LICENSE)
[![Docs](https://img.shields.io/badge/cucumber.pro-aruba-3d10af.svg)](https://app.cucumber.pro/projects/aruba)
[![Gem Version](https://badge.fury.io/rb/aruba.svg)](http://badge.fury.io/rb/aruba)
[![Dependency Status](https://gemnasium.com/cucumber/aruba.svg)](https://gemnasium.com/cucumber/aruba)
[![Code Climate](https://codeclimate.com/github/cucumber/aruba.svg)](https://codeclimate.com/github/cucumber/aruba)
[![Support](https://img.shields.io/badge/cucumber-support-orange.svg)](https://cucumber.io/support)

[![Build Status for "master" on Linux/Mac OS](https://travis-ci.org/cucumber/aruba.svg?branch=master)](https://travis-ci.org/cucumber/aruba) 
[![Build status for "master" on Windows](https://ci.appveyor.com/api/projects/status/jfo2tkqhnrqqcivl/branch/master?svg=true&passingText=master%20windows%20passing&failingText=master%20windows%20failing&pendingText=master%20windows%20pending)](https://ci.appveyor.com/project/cucumberbdd/aruba/branch/master)

**This is the [latest](https://github.com/cucumber/aruba/blob/master/README.md) version of our README.md (Branch: "[master](https://github.com/cucumber/aruba/tree/master)"). There is also [the README of the latest released version of "aruba"](https://github.com/cucumber/aruba/blob/still/README.md) (Branch: "[still](https://github.com/cucumber/aruba/tree/still)").**

## Install

Add this line to your application's `Gemfile`:

~~~ruby
gem 'aruba'
~~~

And then execute:

~~~bash
bundle
~~~

Or install it yourself as:

~~~bash
gem install aruba
~~~

## Usage

### As a user getting started with "aruba"

Our most current documentation to get started with `aruba` as a user can be found on [![See our documentation on Cucumber Pro](https://github.com/cucumber-ltd/brand/raw/master/images/png/notm/cucumber-pro-black/cucumber-pro-black-32.png)](https://app.cucumber.pro/projects/aruba). It is generated from our feature files describing the use of `aruba`.

### As a user getting started with a ruby testing framework

* **Cucumber**:

    If you're new to the "Cucumber" ecosystem, it's worth to visit
[the project's documentation site](https://cucumber.io/docs). This also includes
information about how to write feature files in "Gherkin".

* **RSpec**:

    If you want to use "aruba" with "RSpec" and you need some information about how to use "RSpec", please visit [their website](http://rspec.info/documentation/).

* **minitest**:

    The documentation for "minitest" can be found [here](http://docs.seattlerb.org/minitest/).

### As a developer getting started with "aruba"

A full documentation of the API for developers can be found on
[RubyDoc](http://www.rubydoc.info/github/cucumber/aruba/master/frames).

## Support

### Channels

For support, please have a look at the ["support website"](https://cucumber.io/support) of "Cucumber". You have different options to reach out for help: Recommended for `aruba` are using the "Slack" channels - e.g. "aruba-devs" or "general" ([Register account](https://cucumberbdd-slack-invite.herokuapp.com/)) and the "Issues" page on [GitHub](https://github.com/cucumber/aruba/issues). Addressing one of the maintainers directly would be helpful.

### Maintainers

Currently, this gem is mainly maintained by this group of people:

* [@mvz](https://github.com/mvz)

## Release Policy

We try to comply with [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html).

## Supported Ruby versions

For an up-to-date list of all supported Ruby versions, please see our [`.travis.yml`](https://github.com/cucumber/aruba/blob/master/.travis.yml). We only test against the latest version of a version branch - most times.

## Contributing

Please see the [CONTRIBUTING](CONTRIBUTING.md) file.

## Code branches

We use two branches for development: "master" and "still". The "master" branch
contains the code of the current major version. The "still" branch is used for the
old major version. New features are only added to "master". The "still" branch is
still maintained, but only get fixes for major bugs. The "still" branch should be considered as experimental, as we need to find out how much work it is to maintain two branches of code.

## Build Status

|Version|Linux / OS X|Windows|
| ------ | ------ | ------ |
| master | [![Build Status](https://travis-ci.org/cucumber/aruba.svg?branch=master)](https://travis-ci.org/cucumber/aruba) | [![Build status](https://ci.appveyor.com/api/projects/status/jfo2tkqhnrqqcivl/branch/master?svg=true&passingText=master%20windows%20passing&failingText=master%20windows%20failing&pendingText==master%20windows%20pending)](https://ci.appveyor.com/project/cucumberbdd/aruba/branch/master)|
| still | [![Build Status](https://travis-ci.org/cucumber/aruba.svg?branch=still)](https://travis-ci.org/cucumber/aruba) | [![Build status](https://ci.appveyor.com/api/projects/status/jfo2tkqhnrqqcivl/branch/still?svg=true&passingText=still%20windows%20passing&failingText=still%20windows%20failing&pendingText=master%20windows%20pending)](https://ci.appveyor.com/project/cucumberbdd/aruba/branch/still)
