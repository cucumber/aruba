Feature: Stop commands

  After you've started a command, you might want to stop a command. To do that
  you've got multiple possibilities.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Terminate last command started

    Terminating a command will send `SIGTERM` to the command.

    Given an executable named "bin/cli1" with:
    """bash
    #!/bin/bash

    function term {
      echo Command1
      exit 1
    }

    trap term TERM
    while [ true ]; do sleep 1; done
    """
    And an executable named "bin/cli2" with:
    """bash
    #!/bin/bash

    function term {
      echo Command2
      exit 0
    }

    trap term TERM
    while [ true ]; do sleep 1; done
    exit 2
    """
    And a file named "features/stop.feature" with:
    """
    Feature: Run it
      Background:
        Given the default aruba exit timeout is 1 second

      Scenario: Run command
        Given I wait 5 seconds for a command to start up
        When I run `cli1` in background
        And I run `cli2` in background
        And I terminate the command started last
        Then the exit status should be 0
        And the output should contain:
        \"\"\"
        Command2
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Stop last command started

    Stopping a command will wait n seconds for the command to stop and then
    send `SIGTERM` to the command. Normally "n" is defined by the default exit
    timeout of aruba.

    Given an executable named "bin/cli1" with:
    """bash
    #!/bin/bash

    function term {
      echo Command1
      exit 1
    }

    trap term TERM
    while [ true ]; do sleep 1; done
    """
    And an executable named "bin/cli2" with:
    """bash
    #!/bin/bash

    function term {
      echo Command2
      exit 0
    }

    trap term TERM
    while [ true ]; do sleep 1; done
    exit 2
    """
    And a file named "features/stop.feature" with:
    """
    Feature: Run it
      Background:
        Given the default aruba exit timeout is 5 seconds

      Scenario: Run command
        Given I wait 5 seconds for a command to start up
        When I run `cli1` in background
        And I run `cli2` in background
        And I stop the command started last
        Then the exit status should be 0
        And the output should contain:
        \"\"\"
        Command2
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Terminate command given by commandline

    Terminating a command will send `SIGTERM` to the command.

    Given an executable named "bin/cli1" with:
    """bash
    #!/bin/bash

    function term {
      echo Command1
      exit 1
    }

    trap term TERM
    while [ true ]; do sleep 1; done
    """
    And an executable named "bin/cli2" with:
    """bash
    #!/bin/bash

    function term {
      echo Command2
      exit 0
    }

    trap term TERM
    while [ true ]; do sleep 1; done
    exit 2
    """
    And a file named "features/stop.feature" with:
    """
    Feature: Run it
      Background:
        Given the default aruba exit timeout is 5 seconds

      Scenario: Run command
        Given I wait 5 seconds for a command to start up
        When I run `cli1` in background
        When I run `cli2` in background
        And I terminate the command "cli1"
        Then the exit status should be 0
        And the output should contain:
        \"\"\"
        Command2
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Stop last command given by commandline

    Stopping a command will wait n seconds for the command to stop and then
    send `SIGTERM` to the command. Normally "n" is defined by the default exit
    timeout of aruba.

    Given an executable named "bin/cli1" with:
    """bash
    #!/bin/bash

    function term {
      echo Command1
      exit 1
    }

    trap term TERM
    while [ true ]; do sleep 1; done
    """
    And an executable named "bin/cli2" with:
    """bash
    #!/bin/bash

    function term {
      echo Command2
      exit 0
    }

    trap term TERM
    while [ true ]; do sleep 1; done
    exit 2
    """
    And a file named "features/stop.feature" with:
    """
    Feature: Run it
      Background:
        Given the default aruba exit timeout is 5 seconds

      Scenario: Run command
        Given I wait 5 seconds for a command to start up
        When I run `cli1` in background
        And I run `cli2` in background
        When I stop the command "cli1"
        Then the exit status should be 0
        And the output should contain:
        \"\"\"
        Command2
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Stop command with configured signal

    You can define a default signal which is used to stop all commands.

    Given an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    function hup {
      echo "Exit..."
      exit 0
    }

    function term {
      echo "No! No exit here. Try HUP. I stop the command with exit 1."
      exit 1
    }

    trap hup HUP
    trap term TERM
    while [ true ]; do sleep 1; done
    """
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Run command
        Given the default aruba stop signal is "HUP"
        And the default aruba exit timeout is 5 seconds
        When I run `cli`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass

