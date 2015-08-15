Feature: Install aruba

  Background:
    Given the default aruba exit timeout is 60 seconds

  Scenario: Using rubygems
    Given I successfully run `gem install aruba`
    Then aruba should be installed on the local system
