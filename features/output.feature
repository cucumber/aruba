Feature: Output

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the output should contain" step

  @posix
  Scenario: Detect subset of one-line output
    When I run `printf 'hello world'`
    Then the output should contain "hello world"

  Scenario: Detect absence of one-line output
    When I run `printf "hello world"`
    Then the output should not contain "good-bye"

  Scenario: Detect subset of multiline output
    When I run `printf "hello\nworld"`
    Then the output should contain:
      """
      hello
      """

  Scenario: Detect absence of multiline output
    When I run `printf "hello\nworld"`
    Then the output should not contain:
      """
      good-bye
      """

  @posix
  Scenario: Detect exact one-line output
    When I run `printf "hello world"`
    Then the output should contain exactly:
      """
      hello world
      """

  @ansi
  @posix
  Scenario: Detect exact one-line output with ANSI output
    When I run `printf "\e[36mhello world\e[0m"`
    Then the output should contain exactly:
      """
      \e[36mhello world\e[0m
      """

  @posix
  Scenario: Detect exact one-line output with ANSI output stripped by default
    When I run `printf "\e[36mhello world\e[0m"`
    Then the output should contain exactly:
      """
      hello world
      """

  @posix
  Scenario: Detect exact multiline output
    When I run `printf "hello\nworld"`
    Then the output should contain exactly:
      """
      hello
      world
      """

  @announce
  Scenario: Detect subset of one-line output with regex
    When I run `printf "hello, ruby"`
    Then the output should contain "ruby"
    And the output should match /^hello(, world)?/

  @announce
  @posix
  Scenario: Detect subset of multiline output with regex
    When I run `printf "hello\nworld\nextra line1\nextra line2\nimportant line"`
    Then the output should match:
      """
      he..o
      wor.d
      .*
      important line
      """

  @announce
  Scenario: Negative matching of one-line output with regex
    When I run `printf "hello, ruby"`
    Then the output should contain "ruby"
    And the output should not match /ruby is a better perl$/

  @announce
  @posix
  Scenario: Negative matching of multiline output with regex
    When I run `printf "hello\nworld\nextra line1\nextra line2\nimportant line"`
    Then the output should not match:
      """
      ruby
      is
      a
      .*
      perl
      """

  @announce
  @posix
  Scenario: Match passing exit status and partial output
    When I run `printf "hello\nworld"`
    Then it should pass with:
      """
      hello
      """

  @posix
  Scenario: Match passing exit status and exact output
    When I run `printf "hello\nworld"`
    Then it should pass with exactly:
      """
      hello
      world
      """

  @announce-stdout
  Scenario: Match failing exit status and partial output
    When I run `bash -c '(printf "hello\nworld";exit 99)'`
    Then it should fail with:
      """
      hello
      """

  @posix
  Scenario: Match failing exit status and exact output
    When I run `bash -c '(printf "hello\nworld";exit 99)'`
    Then it should fail with exactly:
      """
      hello
      world
      """

  @announce-stdout
  @posix
  Scenario: Match failing exit status and output with regex
    When I run `bash -c '(printf "hello\nworld";exit 99)'`
    Then it should fail with regex:
      """
      hello\s*world
      """

  @announce-cmd
  @posix
  Scenario: Match output in stdout
    When I run `printf "hello\nworld"`
    Then the stdout should contain "hello"
    Then the stderr should not contain "hello"

  @announce
  Scenario: Match output on several lines
    When I run `printf 'GET /'`
    Then the stdout should contain:
      """
      GET /
      """

  @posix
  Scenario: Match output on several lines using quotes
    When I run `printf 'GET "/"'`
    Then the stdout should contain:
      """
      GET "/"
      """

  @posix
  Scenario: Detect output from all processes
    When I run `printf "hello world!\n"`
    And I run `cat` interactively
    And I type "hola"
    And I type ""
    Then the output should contain exactly:
      """
      hello world!
      hola

      """

  @posix
  Scenario: Detect stdout from all processes
    When I run `printf "hello world!\n"`
    And I run `cat` interactively
    And I type "hola"
    And I type ""
    Then the stdout should contain:
      """
      hello world!
      hola

      """
    And the stderr should not contain anything

  @posix
  Scenario: Detect stderr from all processes
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
