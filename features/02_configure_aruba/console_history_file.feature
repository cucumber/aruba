Feature: Configure the aruba console history file

  As a developer
  I want to configure the history file of aruba console
  In order to have a better isolation of tests

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba_config.rb" with:
    """
    Aruba.configure do |config|
      puts %(The default value is "#{config.console_history_file}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "~/.aruba_history"
    """

  Scenario: Set some value
    Given a file named "features/support/aruba_config.rb" with:
    """
    Aruba.configure do |config|
      config.console_history_file = '~/.config/aruba/history.txt'
    end

    Aruba.configure do |config|
      puts %(The value is "#{config.console_history_file}")
    end
    """
    Then I successfully run `cucumber`
    Then the output should contain:
    """
    The value is "~/.config/aruba/history.txt"
    """
