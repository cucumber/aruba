Feature: Initialize project with aruba

  To add `aruba` to your project you can use the `aruba init`-command.

  Background:
    Given I use the fixture "empty-app"

  Scenario: Create files for RSpec
    When I successfully run `aruba init --test-framework rspec`
    Then the following files should exist:
      | spec/spec_helper.rb |
    And the file "spec/support/aruba.rb" should contain:
    """
    require 'aruba/rspec'
    """
    And the file "Gemfile" should contain:
    """
    gem 'aruba'
    """
    When I successfully run `rspec`
    Then the output should contain:
    """
    0 examples, 0 failures
    """

  Scenario: Create files for Cucumber
    When I successfully run `aruba init --test-framework cucumber`
    Then the file "features/support/aruba.rb" should contain:
    """
    require 'aruba/cucumber'
    """
    And the file "Gemfile" should contain:
    """
    gem 'aruba'
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    0 scenarios
    0 steps
    """

  Scenario: Create files for Cucumber (Default)
    When I successfully run `aruba init`
    Then the file "features/support/aruba.rb" should contain:
    """
    require 'aruba/cucumber'
    """
    And the file "Gemfile" should contain:
    """
    gem 'aruba'
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    0 scenarios
    0 steps
    """

  Scenario: Create files for Minitest
    When I successfully run `aruba init --test-framework minitest`
    Then the following files should exist:
      | test/test_helper.rb |
    And the file "Gemfile" should contain:
    """
    gem 'aruba'
    """
    When I successfully run `ruby -Ilib:test test/use_aruba_with_minitest.rb`
    Then the output should contain:
    """
    0 runs, 0 assertions, 0 failures, 0 errors, 0 skips
    """

  Scenario: Unknown Test Framework
    When I run `aruba init --test-framework unknown`
    Then the output should contain:
    """
    got unknown
    """
