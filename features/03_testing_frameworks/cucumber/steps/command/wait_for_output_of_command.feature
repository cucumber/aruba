Feature: Wait for output of commands

  In order to interact with my program at the right moment
  As a developer using Aruba
  I want to wait for particular output to appear

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Detect subset of one-line output
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `irb --prompt default` interactively
        And I wait for output to contain "irb"
        And I type "puts 6 + 5"
        And I type "exit"
        Then the output should contain "11"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect subset of multiline output
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo -e "hello\nworld"
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `irb --prompt default` interactively
        And I wait for output to contain:
          \"\"\"
          irb(main):001:0>
          \"\"\"
        And I type "puts 'hello'"
        And I type "exit"
        Then the output should contain "hello"
    """
    When I run `cucumber`
    Then the features should all pass
