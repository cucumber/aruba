Feature: Flushing the output of your application

  In order to test processes that output a lot of data
  As a developer using Aruba
  I want to make sure that large amounts of output aren't buffered

  Background:
    Given I use a fixture named "cli-app"

  Scenario: A little output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    for ((c=0; c<256; c = c+1)); do 
      echo -n "a"
    done
    """
    And a file named "features/flushing.feature" with:
    """cucumber
    Feature: Flushing output
      Scenario: Run command
        When I run `cli`
        Then the output should contain "a"
        And the output should be 256 bytes long
        And the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Tons of output
    Given the default aruba exit timeout is 10 seconds
    And an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    for ((c=0; c<65536; c = c+1)); do
      echo -n "a"
    done
    """
    And a file named "features/flushing.feature" with:
    """cucumber
    Feature: Flushing output
      Scenario: Run command
        When I run `cli`
        Then the output should contain "a"
        And the output should be 65536 bytes long
        And the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Tons of interactive output
    Given the default aruba exit timeout is 10 seconds
    And an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    read size; for ((c=0; c<$size; c = c+1)); do
      echo -n "a"
    done
    """
    And a file named "features/flushing.feature" with:
    """cucumber
    Feature: Flushing output
      Scenario: Run command
        When I run `cli` interactively
        And I type "65536"
        Then the output should contain "a"
        And the output should be 65536 bytes long
        And the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
