Feature: Configure if ansi color codes should be stripped off from command output

  As a developer
  I want to strip off ansi color codes
  In order to make checking of those outputs easier

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba_config.rb" with:
    """
    Aruba.configure do |config|
      puts %(The default value is "#{config.remove_ansi_escape_sequences}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "true"
    """

  Scenario: Modify value
    Given a file named "features/support/aruba_config.rb" with:
    """
    Aruba.configure do |config|
      config.remove_ansi_escape_sequences = false
    end

    Aruba.configure do |config|
      puts %(The value is "#{config.remove_ansi_escape_sequences}")
    end
    """
    Then I successfully run `cucumber`
    And the output should contain:
    """
    The value is "false"
    """
