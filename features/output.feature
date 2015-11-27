Feature: All output of commands which were executed

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the output should contain" step

  Background:
    Given I use a fixture named "cli-app"


  Scenario: Detect stdout from named source
    When I run `printf 'hello'`
    And I run `printf 'goodbye'`
    Then the stdout from "printf 'hello'" should contain "hello"
    And the stdout from "printf 'hello'" should contain exactly "hello"
    And the stdout from "printf 'hello'" should contain exactly:
      """
      hello
      """
    And the stderr from "printf 'hello'" should not contain "hello"
    And the stdout from "printf 'goodbye'" should not contain "hello"

  Scenario: Detect stderr from named source
    When I run `bash -c 'printf hello >&2'`
    And I run `printf goodbye`
    Then the stderr from "bash -c 'printf hello >&2'" should contain "hello"
    And the stderr from "bash -c 'printf hello >&2'" should contain exactly "hello"
    And the stderr from "bash -c 'printf hello >&2'" should contain exactly:
      """
      hello
      """
    And the stdout from "bash -c 'printf hello >&2'" should not contain "hello"
    And the stderr from "printf goodbye" should not contain "hello"

  Scenario: Detect second output from named source with custom name
    When I set the environment variable "ARUBA_TEST_VAR" to "first"
    And I run `bash -c 'printf $ARUBA_TEST_VAR'`
    Then the output from "bash -c 'printf $ARUBA_TEST_VAR'" should contain "first"
    When I set the environment variable "ARUBA_TEST_VAR" to "second"
    And I run `bash -c 'printf $ARUBA_TEST_VAR'`
    Then the output from "bash -c 'printf $ARUBA_TEST_VAR'" should contain "second"
