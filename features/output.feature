Feature: All output of commands which were executed

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the output should contain" step

  Background:
    Given I use a fixture named "cli-app"

    @wip
  Scenario: Detect output from all processes normal and interactive ones
    Given an executable named "bin/cli1" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    puts 'This is cli1'
    """
    And an executable named "bin/cli2" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'
    while input = gets do
      break if input == ""
      puts input
    end
    """
    And a file named "features/output.feature" with:
    """
    @debug
    Feature: Run command
      Scenario: Run command
        When I run `cli1`
        When I run `cli2` interactively
        And I type "This is cli2"
        And I type ""
        Then the stdout should contain exactly:
        \"\"\"
        This is cli1
        This is cli2
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect stdout from all processes
    When I run `printf "hello world!\n"`
    And I run `cat` interactively
    And I type "hola"
    And I type ""
    Then the stdout should contain:
      """
      hello world!
      """
    And the stdout should contain:
      """
      hola
      """
    And the stderr should not contain anything

  Scenario: Detect stderr from all processes
    When I run `bash -c 'printf "hello world!\n" >&2'`
    And I run `bash -c 'cat >&2 '` interactively
    And I type "hola"
    And I type ""
    Then the stderr should contain:
    """
    hello world!
    """
    And the stderr should contain:
    """
    hola
    """
    And the stdout should not contain anything

  Scenario: Detect stderr from all processes (deprecated)
    When I run `bash -c 'printf "hello world!\n" >&2'`
    And I run `bash -c 'cat >&2 '` interactively
    And I type "hola"
    And I type ""
    Then the stderr should contain:
    """
    hello world!
    hola
    """
    And the stdout should not contain anything

  Scenario: Detect output from named source
    When I run `printf 'simple'`
    And I run `cat` interactively
    And I type "interactive"
    And I type ""
    Then the output from "printf 'simple'" should contain "simple"
    And the output from "printf 'simple'" should contain exactly "simple"
    And the output from "printf 'simple'" should contain exactly:
      """
      simple
      """
    And the output from "cat" should not contain "simple"

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
    When I set env variable "ARUBA_TEST_VAR" to "first"
    And I run `bash -c 'printf $ARUBA_TEST_VAR'`
    Then the output from "bash -c 'printf $ARUBA_TEST_VAR'" should contain "first"
    When I set env variable "ARUBA_TEST_VAR" to "second"
    And I run `bash -c 'printf $ARUBA_TEST_VAR'`
    Then the output from "bash -c 'printf $ARUBA_TEST_VAR'" should contain "second"
