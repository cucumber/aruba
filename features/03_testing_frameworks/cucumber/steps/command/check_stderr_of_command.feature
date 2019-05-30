Feature: STDERR of commands which were executed

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the stderr should contain" step

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Detect stderr from all processes
    Given a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `bash -c 'printf "hello world!\n" >&2'`
        And I run `bash -c 'cat >&2 '` interactively
        And I type "hola"
        And I type ""
        Then the stderr should contain:
        \"\"\"
        hello world!
        \"\"\"
        And the stderr should contain:
        \"\"\"
        hola
        \"\"\"
        And the stdout should not contain anything
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect stderr from all processes
    Given a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `bash -c 'printf "hello world!\n" >&2'`
        And I run `bash -c 'cat >&2 '` interactively
        And I type "hola"
        And I type ""
        Then the stderr should contain:
        \"\"\"
        hello world!
        hola
        \"\"\"
        And the stdout should not contain anything
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect stderr from named source
    Given a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `bash -c 'printf hello >&2'`
        And I run `printf goodbye`
        Then the stderr from "bash -c 'printf hello >&2'" should contain "hello"
        And the stderr from "bash -c 'printf hello >&2'" should contain exactly "hello"
        And the stderr from "bash -c 'printf hello >&2'" should contain exactly:
        \"\"\"
        hello
        \"\"\"
        And the stdout from "bash -c 'printf hello >&2'" should not contain "hello"
        And the stderr from "printf goodbye" should not contain "hello"
    """
    When I run `cucumber`
    Then the features should all pass
