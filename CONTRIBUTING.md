## About to create a new Github Issue?

We appreciate that. But before you do, please learn our basic rules:

* This is not a support forum. If you have a question, please go to [The Cukes Google Group](http://groups.google.com/group/cukes).
* Do you have an idea for a new feature? Then don't expect it to be implemented unless you or someone else sends a [pull request](https://help.github.com/articles/using-pull-requests). You might be better to start a discussion on [the google group](http://groups.google.com/group/cukes).
* Reporting a bug? Please tell us:
  * which version of Aruba you're using
  * which version of Ruby you're using.
  * How to reproduce it. Bugs with a failing test in a [pull request](https://help.github.com/articles/using-pull-requests) get fixed much quicker. Some bugs may never be fixed.
* Want to paste some code or output? Put \`\`\` on a line above and below your code/output. See [GFM](https://help.github.com/articles/github-flavored-markdown)'s *Fenced Code Blocks* for details.
* We love [pull requests](https://help.github.com/articles/using-pull-requests). But if you don't have a test to go with it we probably won't merge it.

# Contributing to Aruba

This document is a guide for those maintaining Aruba, and others who would like to submit patches.

## Note on Patches/Pull Requests

* Fork the project. Make a branch for your change.
* Make your feature addition or bug fix.
* Make sure your patch is well covered by tests. We don't accept changes that aren't tested.
* Please do not change the Rakefile, version, or history.
  (if you want to have your own version, that is fine but
  bump version in a commit by itself so we can ignore when we merge your change)
* Send us a pull request.

## Running tests using Docker (recommended!)

NOTE: Since custom user shell/app settings can break tests, it's recommended
to use Docker for running tests. The advantages are:

1. You still can run tests based on modified sources.
2. Almost as fast as running tests on your host.
3. Guarantees tests won't be affected by your setup.
4. You can avoid installing all the test-related gems on your system.
5. You can test various combinations of different versions of Ruby and tools.
6. It's easier to reproduce problems without messing around with your own system.
7. You can share your container with others (so they can see the reproduced scenario too).

To run tests using Docker, just run:

    # Automaticaly build Docker image with cached gems and run tests
    bundle exec rake docker:build && bundle exec rake docker:run

or using Docker Compose:

    # Automaticaly build Docker image with cached gems and run tests
    docker-compose run tests

And if you get any failures on a fresh checkout, report them first so they're
fixed quickly.

You can also run specific tests/scenarios/commands, e.g.:

    # Run given cucumber scenario in Docker using rake
    bundle exec rake "docker:run[cucumber features/steps/command/shell.feature:14]"

or

    # Run given cucumber scenario in Docker using Docker Compose
    docker-compose run tests bash -l -c cucumber features/steps/command/shell.feature:14

## Running tests locally (mail fail depending on your setup)

First, bootstrap your environment with this command:

    # Bootstrap environment
    script/bootstrap

(This will check system requirements and install needed gems).

Then, you can run the tests.

    # Run the test suite
    script/test

Or, you can run a specific test or scenario, e.g.

    # Run only selected Cucumber scenario
    script/test cucumber features/steps/command/shell.feature:14


## Installing your own gems used for development

A `Gemfile.local`-file can be used to have your own gems installed to support
your normal development workflow.

Example:

~~~ruby
gem 'pry'
gem 'pry-byebug'
gem 'byebug'
~~~

## Release Process

* Bump the version number in `lib/aruba/version.rb`
* Make sure `History.md` is updated with the upcoming version number, and has entries for all fixes.
* No need to add a `History.md` header at this point - this should be done when a new change is made, later.

Now release it

    bundle update
    bundle exec rake
    git commit -m "Release X.Y.Z"
    rake release

Now send a PR to https://github.com/cucumber/website adding an article about the with details of the new release and merge it - an aruba maintainer should normally allowed to merge PRs on `cucumber/website`. A copy of an old announcement can be used as basis for the new article. After this send an email with the link to the article to cukes@googlegroups.com.

## Gaining Release Karma

To become a release manager, create a pull request adding your name to the list below, and include your Rubygems email address in the ticket. One of the existing Release managers will then add you.

Current release managers:
  * Aslak Hellesøy ([@aslakhellesoy](http://github.com/aslakhellesoy))
  * Dennis Günnewig ([@maxmeyer](http://github.com/maxmeyer), [@dg-rationdata](http://github.com/dg-rationdata))
  * Jarl Friis ([@jarl-dk](https://github.com/jarl-dk))
  * Matt Wynne ([@mattwynne](http://github.com/mattwynne))
  * Tom Brand ([@tom025](https://github.com/tom025))

To grant release karma, issue the following command:

    gem owner aruba --add <NEW OWNER RUBYGEMS EMAIL>
