@announce
Feature: Running ruby
  In order to test a Ruby-based CLI app
  I want to have control over what Ruby version is used,
  possibly using a different Ruby than the one I launch Cucumber with.

  Scenario: Run with ruby 1.9.1
    Given I am using rvm "1.9.1"
    When I run "ruby -e 'puts RUBY_VERSION'"
    Then the output should contain "ruby-1.9.1-p378"
    And the output should not contain "rvm usage"

  Scenario: Run with ruby JRuby
    Given I am using rvm "jruby"
    When I run "ruby -e 'puts JRUBY_VERSION'"
    Then the output should contain "1.5.1"
    And the output should not contain "rvm usage"

  Scenario: Install gems with bundler
    Given I am using rvm "1.9.1"
    And I am using rvm gemset "a-new-gemset-where-no-gems-are-installed" with Gemfile:
      """
      source :gemcutter
      gem 'diff-lcs', '1.1.2'
      """
    When I run "gem list"
    Then the output should match:
      """
      bundler \(\d+\.+\d+\.+\d+\)
      diff-lcs \(\d+\.+\d+\.+\d+\)
      """

  Scenario: Find the version of ruby 1.9.1
    Given I am using rvm "1.9.1"
    When I run "ruby --version"
    Then the output should contain "1.9.1"

  Scenario: Find the version of cucumber on ruby 1.9.1
    Given I am using rvm "1.9.1"
    When I run "cucumber --version"
    Then the output should match /\d+\.+\d+\.+\d+/

  Scenario: Use current ruby
    When I run "ruby --version"
    Then the output should contain the current Ruby version

  Scenario: Use current ruby and a gem bin file
    When I run "rake --version"
    Then the output should contain "rake, version"

  # I have trouble running rvm 1.8.7 in OS X Leopard, which is
  # ruby-1.8.7-p249 (It segfaults rather often). However, a previous
  # patchlevel of 1.8.7 runs fine for me: ruby-1.8.7-tv1_8_7_174
  #
  # In order to provide some level of flexibility (and readability)
  # it should be possible to set up a mapping from a version specified
  # in Gherkin to an *actual* version.
  #
  # In order to make this scenario pass you therefore need to install
  # ruby-1.8.7-tv1_8_7_174 with rvm.
  Scenario: Specify an alias for an rvm
    Given I have a local file named "config/aruba-rvm.yml" with:
      """
      1.8.7: ruby-1.8.7-tv1_8_7_174
      """
    And I am using rvm "1.8.7"
    When I run "ruby --version"
    Then the output should contain "patchlevel 174"

  # To verify this, make sure current rvm is *not* JRuby and run:
  #
  #   ~/.rvm/rubies/jruby-1.4.0/bin/jruby -S cucumber features/running_ruby.feature -n "launched Cucumber"
  @jruby
  Scenario: Don't use rvm, but default to same Ruby as the one that launched Cucumber
    When I run "ruby -e 'puts JRUBY_VERSION if defined?(JRUBY_VERSION)'"
    Then the output should contain the JRuby version
