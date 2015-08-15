Feature: Build Aruba Gem

  As a aruba developer
  I want to build the `aruba` gem
  In order to install it

  Background:
    Given I successfully run `git clone https://github.com/cucumber/aruba.git`
    And I cd to "aruba"

  Scenario: Building aruba using rake task

    To build the `aruba`-gem you can use the `build`-rake task.

    Given I successfully run `rake build`
    Then a file matching %r<pkg/aruba.*\.gem> should exist
