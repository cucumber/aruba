@announce
Feature: Running ruby
  In order to test a Ruby-based CLI app
  I want to have control over what Ruby version is used,
  possibly using a different Ruby than the one I launch Cucumber with.

  Scenario: Run with ruby 1.9.1
    Given I am using rvm "1.9.1"
    When I run "ruby -e 'puts RUBY_VERSION'"
    Then I should see "ruby-1.9.1-p378"
    And I should not see "rvm usage"

  Scenario: Run with ruby JRuby
    Given I am using rvm "jruby-1.4.0"
    When I run "ruby -e 'puts JRUBY_VERSION'"
    Then I should see "1.4.0"
    And I should not see "rvm usage"

  Scenario: Specify both rvm and gemset
    Given I am using rvm "1.9.1"
    And I am using an empty rvm gemset "a-gemset-where-nothing-is-installed-except-default-rvm-gems"
    When I run "gem list"
    Then I should see:
      """

      rake (0.8.7)
      rubygems-update (1.3.6)

      """

  Scenario: Find the version of ruby 1.9.1
    Given I am using rvm "1.9.1"
    When I run "ruby --version"
    Then I should see "1.9.1"

  Scenario: Find the version of cucumber on ruby 1.9.1
    Given I am using rvm "1.9.1"
    When I run "cucumber --version"
    Then I should see "0.6.3"

  Scenario: Use current ruby
    When I run "ruby --version"
    Then I should see the current Ruby version

  Scenario: Use current ruby and a gem bin file
    When I run "rake --version"
    Then I should see "rake, version"

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
    Then I should see "patchlevel 174"

  # To verify this, make sure current rvm is *not* JRuby and run:
  #
  #   ~/.rvm/rubies/jruby-1.4.0/bin/jruby -S cucumber features/running_ruby.feature -n "launched Cucumber"
  @jruby
  Scenario: Don't use rvm, but default to same Ruby as the one that launched Cucumber
    When I run "ruby -e 'puts JRUBY_VERSION if defined?(JRUBY_VERSION)'"
    Then I should see the JRuby version