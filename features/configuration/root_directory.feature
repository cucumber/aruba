Feature: Use root directory of aruba

  As a developer
  I want to use the root directory of aruba
  In order to use it elsewhere

  Scenario: Default configuration
    Given I use a fixture named "cli-app"
    And a file named "features/support/aruba.rb" with:
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


