Feature: Run commands

  There are several steps to run commands with `aruba`.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Run command found in path
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    exit 0
    """
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Run command
        When I run `cli`
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Relative command
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    exit 0
    """
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Run command
        When I run `bin/cli`
    """
    When I run `cucumber`
    Then the features should all pass
