[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/cucumber/aruba/master/LICENSE)
[![Docs](https://img.shields.io/badge/cucumber.pro-aruba-3d10af.svg)](https://app.cucumber.pro/projects/aruba)
[![Gem Version](https://badge.fury.io/rb/aruba.svg)](http://badge.fury.io/rb/aruba)
[![Code Climate](https://codeclimate.com/github/cucumber/aruba.svg)](https://codeclimate.com/github/cucumber/aruba)
[![Support](https://img.shields.io/badge/cucumber-support-orange.svg)](https://cucumber.io/support)

[![Travis CI build status](https://travis-ci.org/cucumber/aruba.svg)](https://travis-ci.org/cucumber/aruba) 
[![Appveyor build status](https://ci.appveyor.com/api/projects/status/jfo2tkqhnrqqcivl?svg=true)](https://ci.appveyor.com/project/cucumberbdd/aruba)

## Install

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

## Usage

### As a user getting started with Aruba

Our most current documentation to get started with Aruba as a user can be
found on [Cucumber Jam](https://app.cucumber.pro/projects/aruba).
It is generated from our feature files describing the use of Aruba.

### As a user getting started with a ruby testing framework

* **Cucumber**:

    If you're new to the Cucumber ecosystem, it's worth to visit
[the project's documentation site](https://cucumber.io/docs). This also includes
information about how to write feature files in Gherkin.

* **RSpec**:

    If you want to use Aruba with RSpec and you need some information about how to use RSpec, please visit [their website](http://rspec.info/documentation/).

* **minitest**:

    The documentation for minitest can be found [here](http://docs.seattlerb.org/minitest/).

### As a developer getting started with Aruba

A full documentation of the API for developers can be found on
[RubyDoc](http://www.rubydoc.info/gems/aruba).

## Support

### Channels

For support, please have a look at the [support website](https://cucumber.io/support)
of Cucumber. You have different options to reach out for help: Recommended for
Aruba are using the Slack channels &mdash; e.g. `committers-aruba` or `help-cucumber-ruby`
&mdash; ([register account](https://cucumberbdd-slack-invite.herokuapp.com/)), and the
[Issues page on GitHub](https://github.com/cucumber/aruba/issues).

### Maintainers

Currently, this gem is mainly maintained by this group of people:

* [@mvz](https://github.com/mvz)

## Release Policy

We try to comply with [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html).

## Supported Ruby versions

Aruba is supported on Ruby 2.4 and up, and tested against CRuby 2.4, 2.5, 2.6
and 2.7, and JRuby 9.2.

## Supported operating systems

Aruba is fully tested in CI on Linux and MacOS. On Windows, only RSpec tests
are run, so YMMV. Full Windows support is a work in progress.

## Contributing

Please see the [CONTRIBUTING](CONTRIBUTING.md) file.

## Code branches

Development takes place in the `master` branch and currently targets the 1.x
releases. If necessary, maintenance of the old 0.14.x releases takes place in
the `0-14-stable` branch. Stable branches will not be created until absolutely
necessary.

## License

See the file [LICENSE](LICENSE).
