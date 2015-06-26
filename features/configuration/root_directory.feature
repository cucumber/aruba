Feature: Use root directory of aruba

  As a developer
  I want to use the root directory of aruba
  In order to use it elsewhere

  Background:
    Given I use the fixture "cli-app"
    And the default feature-test

  Scenario: Default configuration
    Given a file named "features/support/aruba.rb" with:
    """
    Aruba.configure do |config|
      puts config.root_directory
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    tmp/aruba
    """


