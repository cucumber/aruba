@announce
Feature: Running ruby
  In order to test a Ruby-based CLI app
  I want to have control over what Ruby version is used,
  possibly using a different Ruby than the one I launch Cucumber with.

  Scenario Outline: Specify a certain rvm
    Given I am using rvm "<rvm_ruby_version>"
    When I run "ruby -e 'puts RUBY_VERSION'"
    Then I should see "<see>"
    And I should not see "<not_see>"

    Examples:
      | rvm_ruby_version | see                                     | not_see   |
      | 1.9.1        | ruby-1.9.1-p378                         | rvm usage |
      | jruby-1.4.0  | jruby 1.4.0 (ruby 1.8.7 patchlevel 174) | rvm usage |
      | bogus        | Unrecognized command line argument      | XX        |

  Scenario: Specify both rvm and gemset
    Given I am using rvm "1.9.1"
    Given I am using rvm gemset "a-gemset-where-nothing-is-installed-except-default-rvm-gems"
    When I run "ruby -S gem list"
    Then I should see:
      """

      rake (0.8.7)
      rubygems-update (1.3.5)

      """

  # To verify this, make sure current rvm is *not* JRuby and run:
  #
  #   ~/.rvm/rubies/jruby-1.4.0/bin/jruby -S cucumber features/running_ruby.feature
  @jruby
  Scenario: Don't use rvm, but default to same Ruby as the one that launched Cucumber
    When I run "ruby -e 'puts JRUBY_VERSION'"
    Then I should see the JRuby version