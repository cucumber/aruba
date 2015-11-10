Feature: Overview of steps

  Given you're a system administrator
  Who would like to use `aruba`
  But didn't know which steps are available

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Use information found in repository
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    git clone https://github.com/cucumber/aruba.git
    cd aruba
    grep -E "When|Given|Then" lib/aruba/cucumber/*.rb | awk -F ":" '{ $1 = ""; print $0}' |sort
    """
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Run command
        When I run `cli`
        Then the output should contain:
        \"\"\"
        Cloning into 'aruba'...
        \"\"\"
        And the output should contain:
        \"\"\"
        Given(/^
        \"\"\"
        And the output should contain:
        \"\"\"
        When(/^
        \"\"\"
        And the output should contain:
        \"\"\"
        Then(/^
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Use cucumber output formatter
    Given a file named "features/run.feature" with:
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
