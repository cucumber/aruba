Feature: Run test suite of aruba

  As a aruba developer
  I want to run the test suite of aruba
  In order to make changes to it

  Background:
    Given the default aruba exit timeout is 120 seconds
    And I successfully run `git clone https://github.com/cucumber/aruba.git`
    And I cd to "aruba"

  @ignore
  Scenario: Testing user interface
    Given I successfully run `cucumber`
    Then the features should all pass

  @unsupported-on-ruby-older-193
  Scenario: Testing compliance to ruby community guide
    Given I successfully run `rubocop`
    Then the features should all pass

  Scenario: Testing api
    Given I successfully run `rspec`
    Then the features should all pass
