Feature: Append environment variable via "cucumber"-step

  It is quite handy to modify the environment of a process. To make this
  possible, `aruba` provides several steps. One of these is
  `I append the values to environment variables:`-step. Using this step appends
  the values. Each variable name and each value is converted to a string.
  Otherwise `ruby` would complain about an invalid argument.

  Background:
    Given I use the fixture "cli-app"
    And an executable named "bin/cli" with:
    """
    #!/bin/bash

    echo $LONG_LONG_VARIABLE
    """
    And a file named "features/support/variables.rb" with:
    """
    ENV['LONG_LONG_VARIABLE'] = '1'
    """

  Scenario: Append environment variable by using a step given in table
    Given a file named "features/home_variable.feature" with:
    """
    Feature: Environment Variable
      Scenario: Run command
        Given I append the values to the environment variables:
          | variable           | value      |
          | LONG_LONG_VARIABLE | long_value |
        When I run `cli`
        Then the output should contain:
        \"\"\"
        1long_value
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Append single environment variable by using a step
    Given a file named "features/home_variable.feature" with:
    """
    Feature: Environment Variable
      Scenario: Run command
        Given I append "long_value" to the environment variable "LONG_LONG_VARIABLE"
        When I run `cli`
        Then the output should contain:
        \"\"\"
        1long_value
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass
