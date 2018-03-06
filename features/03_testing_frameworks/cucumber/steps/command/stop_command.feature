Feature: Stop commands

  After you've started a command, you might want to stop a command. To do that
  you've got multiple possibilities.

  On "JRuby" it's not possible to read the output of command which `echo`s a
  string in a `signal`-handler - `TERM`, `HUP` etc. So please don't write
  tests, which check on this, if your script needs to run on "JRuby". All other
  output is logged to `STDERR` and/or `STDOUT` as normal.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Terminate last command started

    Terminating a command will send `SIGTERM` to the command.

    Given an executable named "bin/aruba-test-cli1" with:
    """bash
    #!/bin/bash

    function term {
      exit 100
    }

    trap term TERM
    echo "Hello, Aruba!"
    while [ true ]; do sleep 0.1; done
    exit 1
    """
    And an executable named "bin/aruba-test-cli2" with:
    """bash
    #!/bin/bash

    function term {
      exit 155
    }

    trap term TERM
    echo "Hello, Aruba!"
    while [ true ]; do sleep 0.1; done
    exit 1
    """
    And a file named "features/stop.feature" with:
    """
    Feature: Run it
      Scenario: Run command
        Given the default aruba exit timeout is 0.2 seconds
        And I wait 0.1 seconds for a command to start up
        When I run `aruba-test-cli1` in background
        And I run `aruba-test-cli2` in background
        And I terminate the command started last
        Then the exit status should be 155
        And the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Stop last command started

    Stopping a command will wait n seconds for the command to stop and then
    send `SIGTERM` to the command. Normally "n" is defined by the default exit
    timeout of aruba.

    Given an executable named "bin/aruba-test-cli1" with:
    """bash
    #!/bin/bash

    function term {
      exit 100
    }

    trap term TERM
    echo "Hello, Aruba!"
    while [ true ]; do sleep 0.1; done
    exit 1
    """
    And an executable named "bin/aruba-test-cli2" with:
    """bash
    #!/bin/bash

    function term {
      exit 155
    }

    trap term TERM
    echo "Hello, Aruba!"
    while [ true ]; do sleep 0.1; done
    exit 1
    """
    And a file named "features/stop.feature" with:
    """
    Feature: Run it
      Background:

      Scenario: Run command
        Given the default aruba exit timeout is 0.2 seconds
        And I wait 0.1 seconds for a command to start up
        When I run `aruba-test-cli1` in background
        And I run `aruba-test-cli2` in background
        And I stop the command started last
        Then the exit status should be 155
        And the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Terminate command given by commandline

    Pass the commandline to the step to find the command, which should be
    stopped.

    Given an executable named "bin/aruba-test-cli1" with:
    """bash
    #!/bin/bash

    function term {
      exit 100
    }

    trap term TERM
    echo "Hello, Aruba!"
    while [ true ]; do sleep 0.1; done
    """
    And an executable named "bin/aruba-test-cli2" with:
    """bash
    #!/bin/bash

    function term {
      exit 155
    }

    trap term TERM
    echo "Hello, Aruba!"
    while [ true ]; do sleep 0.1; done
    exit 2
    """
    And a file named "features/stop.feature" with:
    """
    Feature: Run it
      Background:
        Given the default aruba exit timeout is 0.2 seconds

      Scenario: Run command
        Given I wait 0.1 seconds for a command to start up
        When I run `aruba-test-cli1` in background
        When I run `aruba-test-cli2` in background
        And I terminate the command "aruba-test-cli1"
        Then the exit status should be 100
        And the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Stop command given by commandline

    Stopping a command will wait n seconds for the command to stop and then
    send `SIGTERM` to the command. Normally "n" is defined by the default exit
    timeout of aruba.

    Given an executable named "bin/aruba-test-cli1" with:
    """bash
    #!/bin/bash

    function term {
      exit 155
    }

    trap term TERM
    echo "Hello, Aruba!"
    while [ true ]; do sleep 0.1; done
    exit 1
    """
    And an executable named "bin/aruba-test-cli2" with:
    """bash
    #!/bin/bash

    function term {
      exit 100
    }

    trap term TERM
    echo "Hello, Aruba!"
    while [ true ]; do sleep 0.1; done
    exit 1
    """
    And a file named "features/stop.feature" with:
    """
    Feature: Run it
      Background:
        Given the default aruba exit timeout is 0.2 seconds

      Scenario: Run command
        Given I wait 0.1 seconds for a command to start up
        When I run `aruba-test-cli1` in background
        And I run `aruba-test-cli2` in background
        When I stop the command "aruba-test-cli1"
        Then the exit status should be 155
        And the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Stop command with configured signal

    You can define a default signal which is used to stop all commands.

    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    function hup {
      exit 155
    }

    function term {
      exit 100
    }

    trap hup HUP
    trap term TERM
    echo "Hello, Aruba!"
    while [ true ]; do sleep 0.1; done
    exit 1
    """
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Run command
        Given the default aruba stop signal is "HUP"
        And the default aruba exit timeout is 0.2 seconds
        When I run `aruba-test-cli`
        Then the exit status should be 155
    """
    When I run `cucumber`
    Then the features should all pass

  @requires-ruby-platform-mri
  Scenario: STDERR/STDOUT is captured from signal handlers

     STDERR/STDOUT is written normally on MRI if output was written in "signal"-handler

     This is currently broken on JRuby.

    Given an executable named "bin/aruba-test-cli1" with:
    """bash
    #!/bin/bash

    function term {
      echo 'Hello, TERM'
      exit 100
    }

    trap term TERM
    echo "Hello, Aruba!"
    while [ true ]; do sleep 0.1; done
    exit 1
    """
    And a file named "features/stop.feature" with:
    """
    Feature: Run it
      Scenario: Run command
        Given the default aruba exit timeout is 0.2 seconds
        And I wait 0.1 seconds for a command to start up
        When I run `aruba-test-cli1` in background
        And I terminate the command started last
        Then the exit status should be 100
        And the output should contain:
        \"\"\"
        Hello, TERM
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass
