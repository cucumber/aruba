# Aruba

[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/cucumber/aruba/main/LICENSE)
[![Gem Version](https://badge.fury.io/rb/aruba.svg)](http://badge.fury.io/rb/aruba)
[![Support](https://img.shields.io/badge/cucumber-support-orange.svg)](https://cucumber.io/support)
[![Build Status](https://github.com/cucumber/aruba/actions/workflows/ruby.yml/badge.svg)](https://github.com/cucumber/aruba/actions/workflows/ruby.yml)

## Install

Add this line to your application's `Gemfile`:

```ruby
gem 'aruba', '~> 2.3'
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
found in [./features/](https://github.com/cucumber/aruba/tree/main/features/).

### As a user getting started with a ruby testing framework

* **Cucumber**:

    If you're new to the Cucumber ecosystem, it's worth to visit
[the project's documentation site](https://cucumber.io/docs). This also includes
information about how to write feature files in Gherkin.

* **RSpec**:

    If you want to use Aruba with RSpec and you need some information about how
    to use RSpec, please visit [their website](http://rspec.info/documentation/).

* **minitest**:

    The documentation for minitest can be found [here](http://docs.seattlerb.org/minitest/).

### As a developer getting started with Aruba

A full documentation of the API for developers can be found on
[RubyDoc](http://www.rubydoc.info/gems/aruba).

## Support

For support, please have a look at the [support website](https://cucumber.io/support)
of Cucumber. You have different options to reach out for help: Recommended for
Aruba would be using the [Community Discord](https://github.com/cucumber#get-in-touch).

Concrete issues can be reported via the
[Issues page on GitHub](https://github.com/cucumber/aruba/issues).

## Maintainers

Currently, this gem is mainly maintained by this group of people:

* [@mvz](https://github.com/mvz)

## Release Policy

We use [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html). We
depend on rubygems to ensure correct dependency versions, so dropping support
for older dependencies and Ruby versions will not result in a major version
bump.

## Supported Ruby versions

Aruba is supported on Ruby 3.0 and up, and tested against CRuby 3.0, 3.1, 3.2,
3.3 and 3.4, and JRuby 9.4.

## Supported Cucumber versions

Aruba is supported on and tested with Cucumber versions 8 and 9.

## Supported operating systems

Aruba is fully tested in CI on Linux and MacOS. On Windows, only RSpec tests
are run, so YMMV. Full Windows support is a work in progress.

## Contributing

Please see the [CONTRIBUTING](CONTRIBUTING.md) file.

## Code branches

Development takes place in the `main` branch and currently targets the 2.x
releases. If necessary, maintenance of the old 1.1.x releases will take place
in a `1-1-stable` branch, and of 0.14.x releases in the `0-14-stable` branch.
Stable branches will not be created until absolutely necessary.

## License

See the file [LICENSE](LICENSE).
