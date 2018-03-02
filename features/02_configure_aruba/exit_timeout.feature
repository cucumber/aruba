Feature: Configure timeout for command execution

  As a developer
  I want to configure the timeout when executing a command
  In order to support some longer running commands

  Background:
    Given I use the fixture "cli-app"
    And an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    trap "exit 128" SIGTERM SIGINT
    sleep $*
    """

  Scenario: Default value
    Given a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      puts %(The default value is "#{config.exit_timeout}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "15"
    """

  Scenario: Modify value
    Given a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      config.exit_timeout = 0.2
    end
    """
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Fast command
        When I run `aruba-test-cli 0.1`
        Then the exit status should be 0
    """
    Then I successfully run `cucumber`

  Scenario: Fails if takes longer
    Given a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      config.exit_timeout = 0.1
    end
    """
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Fast command
        When I run `aruba-test-cli 0.2`
        Then the exit status should be 0
    """
    Then I run `cucumber`
    And the exit status should be 1
