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

  Scenario: Activate desired announcers when running command fails
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    echo "Hello, I'm STDOUT"
    exit 1
    """
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Run command
        When I successfully run `cli`
    """
    And I append to "features/support/env.rb" with:
    """
    Before do
      aruba.config.activate_announcer_on_command_failure = [:stdout]
    end
    """
    When I run `cucumber`
    Then the features should not pass
    And the output should contain:
    """
    <<-STDOUT
    Hello, I'm STDOUT

    STDOUT
    """
