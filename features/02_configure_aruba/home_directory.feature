Feature: Configure the home directory to be used with aruba

  As a developer
  I want to use the home directory
  In order to use it elsewhere

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      puts %(The default value is "#{config.home_directory}")
    end
    """
    When I successfully run `cucumber`
    Then the output should match:
    """
    The default value is "/.*/tmp/aruba"
    """
