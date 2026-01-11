Feature: Check exit status of commands

  Use the `the exit status should be \d`-step to check the exit status of the
  last command which was finished. If no commands have finished yet, it stops
  the one that was started last.

  If you have started multiple commands, to make sure the correct command's
  exit status is checked, you can explicitly specify the command to check.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Test for exit status of 0
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    exit 0
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Exit status
      Scenario: Run command
        When I run `aruba-test-cli`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Test for exit status 1
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    exit 1
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        When I run `aruba-test-cli`
        Then the exit status should be 1
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Test for non-zero exit status
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    exit 1
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        When I run `aruba-test-cli`
        Then the exit status should not be 0
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Successfully run something
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    exit 0
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        When I successfully run `aruba-test-cli`
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Fail to run something successfully
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    exit 1
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        When I successfully run `aruba-test-cli`
    """
    When I run `cucumber`
    Then the features should not all pass

  Scenario: Overwrite the default exit timeout via step
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    sleep 0.1
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        Given the default aruba exit timeout is 0.4 seconds
        When I successfully run `aruba-test-cli`
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Successfully run something longer then the default time
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    sleep 0.1
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        Given the default aruba exit timeout is 0 seconds
        When I successfully run `aruba-test-cli` for up to 0.4 seconds
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Unsuccessfully run something that takes too long
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    sleep 1
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        Given the default aruba exit timeout is 0 seconds
        When I successfully run `aruba-test-cli`
    """
    When I run `cucumber`
    Then the features should not all pass with:
    """
    expected "aruba-test-cli" to have finished in time
    """

  Scenario: Checking for exit status when multiple commands were started
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    sleep 0.1
    exit $1
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        Given I run `aruba-test-cli 0` in background
        And I run `aruba-test-cli 1` in background
        Then the exit status of `aruba-test-cli 1` should be 1
        And the exit status of `aruba-test-cli 0` should be 0
        And the exit status of `aruba-test-cli 1` should not be 0
        And the exit status of `aruba-test-cli 0` should not be 1
    """
    When I run `cucumber`
    Then the features should all pass
