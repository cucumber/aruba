Feature: Configure timeout for command execution

  As a developer
  I want to configure the timeout when executing a command
  In order to support some longer running commands

  Background:
    Given I use the fixture "cli-app"
    And the default feature-test

  Scenario: Default value
    Given a file named "features/support/aruba.rb" with:
    """
    Aruba.configure do |config|
      puts %(The default value is "#{config.exit_timeout}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "3"
    """

  Scenario: Modify value
    Given a file named "bin/cli" with:
    """
    sleep 1
    """
    And a file named "features/support/aruba.rb" with:
    """
    Aruba.configure do |config|
      config.exit_timeout = 2
    end
    """
    Then I successfully run `cucumber`

  Scenario: Fails if takes longer
    Given a file named "bin/cli" with:
    """
    sleep 5
    """
    And a file named "features/support/aruba.rb" with:
    """
    Aruba.configure do |config|
      config.exit_timeout = 1
    end
    """
    Then I run `cucumber`
    And the exit status should be 1
