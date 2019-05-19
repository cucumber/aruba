Feature: STDOUT of commands which were executed

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the stdout should contain" step

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Match output in stdout
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo -e "hello\nworld"
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `aruba-test-cli`
        Then the stdout should contain "hello"
        Then the stderr should not contain "hello"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Match stdout on several lines
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'GET /'
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `aruba-test-cli`
        Then the stdout should contain:
        \"\"\"
        GET /
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Match output on several lines where stdout contains quotes
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'GET "/"'
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `aruba-test-cli`
        Then the stdout should contain:
        \"\"\"
        GET "/"
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect stdout from all processes including interactive ones
    Given a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `printf "hello world!\n"`
        And I run `cat` interactively
        And I type "hola"
        And I type ""
        Then the stdout should contain:
        \"\"\"
        hello world!
        \"\"\"
        And the stdout should contain:
        \"\"\"
        hola
        \"\"\"
        And the stderr should not contain anything
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect stdout from named source
    Given a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `printf 'hello'`
        And I run `printf 'goodbye'`
        Then the stdout from "printf 'hello'" should contain "hello"
        And the stdout from "printf 'hello'" should contain exactly "hello"
        And the stdout from "printf 'hello'" should contain exactly:
        \"\"\"
        hello
        \"\"\"
        And the stderr from "printf 'hello'" should not contain "hello"
        And the stdout from "printf 'goodbye'" should not contain "hello"
    """
    When I run `cucumber`
    Then the features should all pass


