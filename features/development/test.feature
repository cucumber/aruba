Feature: Build Aruba Gem

  As a aruba developer
  I want to build the `aruba` gem
  In order to install it

  Background:
    Given the default aruba timeout is 10 seconds
    And I successfully run `git clone https://github.com/cucumber/aruba.git`
    And I cd to "aruba"

    @ignore
  Scenario: Testing user interface
    Given I successfully run `cucumber`
    Then the features should all pass

  Scenario: Testing compliance to ruby community guide
    Given I successfully run `rubocop`
    Then the features should all pass

  Scenario: Testing api
    Given I successfully run `rspec`
    Then the features should all pass
