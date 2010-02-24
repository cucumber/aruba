@announce
Feature: Running ruby
  In order to test a Ruby-based CLI app
  I want to have control over what Ruby version is used,
  possibly using a different Ruby than the one I launch Cucumber with.

  Scenario Outline: Specify a certain rvm
    Given I am using rvm "<ruby_version>"
    When I run "ruby -e 'puts RUBY_VERSION'"
    Then I should see "<see>"
    And I should not see "<not_see>"

    Examples:
      | ruby_version | see                                     | not_see   |
      | 1.9.1        | ruby-1.9.1-p378                         | rvm usage |
      | jruby-1.4.0  | jruby 1.4.0 (ruby 1.8.7 patchlevel 174) | rvm usage |
      | bogus        | Unrecognized command line argument      | XX        |

  Scenario: Default to same Ruby as the one that launched Cucumber
    When I run "ruby -e 'puts \"hello\\nworld\"'"
