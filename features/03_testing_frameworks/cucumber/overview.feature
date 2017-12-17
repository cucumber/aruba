Feature: Overview of steps

  Given you're a system administrator
  Who would like to use `aruba`
  But didn't know which steps are available

  Scenario: Use cucumber output formatter
    Given I use a fixture named "cli-app"
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Run command
        Given a directory named "features"
        And a file named "features/support/env.rb" with:
        \"\"\"
        require 'aruba/cucumber'
        \"\"\"
        When I run `cucumber --format stepdefs`
        Then the output should contain:
        \"\"\"
        NOT MATCHED BY ANY STEPS
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass
