Feature: Install aruba

  Background:
    Given the default aruba timeout is 10 seconds

  # @wip
  Scenario: Using rubygems
    Given I successfully run `gem install aruba`
    Then aruba should be installed on the local system
