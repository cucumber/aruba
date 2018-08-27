Feature: Check exit status of commands

  Use the `the exit status should be \d`-step to check the exit status of the
  last command which was executed.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Test for exit status of 0
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    exit 0
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Exit status
      Scenario: Run command
        When I run `cli`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Test for exit status 1
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    exit 1
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        When I run `cli`
        Then the exit status should be 1
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Test for non-zero exit status
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    exit 1
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        When I run `cli`
        Then the exit status should not be 0
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Successfully run something
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    exit 0
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        When I successfully run `cli`
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Fail to run something successfully
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    exit 1
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        When I successfully run `cli`
    """
    When I run `cucumber`
    Then the features should not all pass

  Scenario: Overwrite the default exit timeout via step
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    sleep 1
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        Given the default aruba exit timeout is 2 seconds
        When I successfully run `cli`
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Successfully run something longer then the default time
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    sleep 1
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        Given the default aruba exit timeout is 0 seconds
        When I successfully run `cli` for up to 2 seconds
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Unsuccessfully run something that takes too long
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    sleep 2
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Failing program
      Scenario: Run command
        Given the default aruba exit timeout is 0 seconds
        When I successfully run `cli` for up to 1 seconds
    """
    When I run `cucumber`
    Then the features should not all pass with:
    """
    expected "cli" to have finished in time
    """
