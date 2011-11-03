Feature: Output

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the output should contain" step

  @posix
  Scenario: Run unknown command
    When I run `neverever gonna work`
    Then the output should contain:
      """
      No such file or directory - neverever
      """

  @posix
  Scenario: Detect subset of one-line output
    When I run `ruby -e 'puts \"hello world\"'`
    Then the output should contain "hello world"

  @posix
  Scenario: Detect subset of one-line output
    When I run `echo 'hello world'`
    Then the output should contain "hello world"

  Scenario: Detect absence of one-line output
    When I run `ruby -e 'puts \"hello world\"'`
    Then the output should not contain "good-bye"

  Scenario: Detect subset of multiline output
    When I run `ruby -e 'puts \"hello\\nworld\"'`
    Then the output should contain:
      """
      hello
      """

  Scenario: Detect subset of multiline output
    When I run `ruby -e 'puts \"hello\\nworld\"'`
    Then the output should not contain:
      """
      good-bye
      """

  @posix
  Scenario: Detect exact one-line output
    When I run `ruby -e 'puts \"hello world\"'`
    Then the output should contain exactly:
      """
      hello world
      
      """

  @ansi
  @posix
  Scenario: Detect exact one-line output with ANSI output
    When I run `ruby -e 'puts \"\e[36mhello world\e[0m\"'`
    Then the output should contain exactly:
      """
      \e[36mhello world\e[0m

      """

  @posix
  Scenario: Detect exact one-line output with ANSI output stripped by default
    When I run `ruby -e 'puts \"\e[36mhello world\e[0m\"'`
    Then the output should contain exactly:
      """
      hello world

      """
  @posix
  Scenario: Detect exact multiline output
    When I run `ruby -e 'puts "hello\nworld"'`
    Then the output should contain exactly:
      """
      hello
      world

      """

  @announce
  Scenario: Detect subset of one-line output with regex
    When I run `ruby --version`
    Then the output should contain "ruby"
    And the output should match /ruby ([\d]+\.[\d]+\.[\d]+)(\w*\d*)? \(.*$/

  @announce
  @posix
  Scenario: Detect subset of multiline output with regex
    When I run `ruby -e 'puts "hello\nworld\nextra line1\nextra line2\nimportant line"'`
    Then the output should match:
      """
      he..o
      wor.d
      .*
      important line
      """

  @announce
  @posix
  Scenario: Match passing exit status and partial output
    When I run `ruby -e 'puts "hello\nworld"'`
    Then it should pass with:
      """
      hello
      """

  @posix
  Scenario: Match passing exit status and exact output
    When I run `ruby -e 'puts "hello\nworld"'`
    Then it should pass with exactly:
      """
      hello
      world

      """

  @announce-stdout
  Scenario: Match failing exit status and partial output
    When I run `ruby -e 'puts \"hello\\nworld\";exit 99'`
    Then it should fail with:
      """
      hello
      """

  @posix
  Scenario: Match failing exit status and exact output
    When I run `ruby -e 'puts "hello\nworld";exit 99'`
    Then it should fail with exactly:
      """
      hello
      world

      """

  @announce-stdout
  @posix
  Scenario: Match failing exit status and output with regex
    When I run `ruby -e 'puts \"hello\\nworld\";exit 99'`
    Then it should fail with regex:
      """
      hello\s*world
      """

  @announce-cmd
  @posix
  Scenario: Match output in stdout
    When I run `ruby -e 'puts \"hello\\nworld\"'`
    Then the stdout should contain "hello"
    Then the stderr should not contain "hello"

  @announce
  Scenario: Match output on several lines
    When I run `ruby -e 'puts %{GET /}'`
    Then the stdout should contain:
      """
      GET /
      """

  @posix
  Scenario: Match output on several lines using quotes
    When I run `ruby -e 'puts %{GET "/"}'`
    Then the stdout should contain:
      """
      GET "/"
      """

  @posix
  Scenario: Match output in stdout
    When I run `ruby -e 'puts \"hello\\nworld\"'`
    Then the stdout should contain "hello"
    Then the stderr should not contain "hello"


  @posix
  Scenario: Detect output from all processes
    When I run `ruby -e 'puts \"hello world!\"'`
    And I run `ruby -e 'puts gets.chomp.reverse'` interactively
    And I type "hello"
    Then the output should contain exactly:
      """
      hello world!
      olleh

      """

  @posix
  Scenario: Detect stdout from all processes
    When I run `ruby -e 'puts \"hello world!\"'`
    And I run `ruby -e 'puts gets.chomp.reverse'` interactively
    And I type "hello"
    Then the stdout should contain:
      """
      hello world!
      olleh
      """
    And the stderr should not contain:
      """
      hello world!
      olleh
      """

  @posix
  Scenario: Detect stderr from all processes
    When I run `ruby -e 'STDERR.puts \"hello world!\"'`
    And I run `ruby -e 'STDERR.puts gets.chomp.reverse'` interactively
    And I type "hello"
    Then the stderr should contain:
      """
      hello world!
      olleh
      """
    And the stdout should not contain:
      """
      hello world!
      olleh
      """

  Scenario: Detect output from named source
    When I run `ruby -e 'puts :simple'`
    And I run `ruby -e 'puts gets.chomp'` interactively
    And I type "interactive"
    Then the output from "ruby -e 'puts :simple'" should contain "simple"
    And the output from "ruby -e 'puts gets.chomp'" should not contain "simple"

  Scenario: Detect stdout from named source
    When I run `ruby -e 'puts :hello'`
    And I run `ruby -e 'puts :goodbye'`
    Then the stdout from "ruby -e 'puts :hello'" should contain "hello"
    And the stderr from "ruby -e 'puts :hello'" should not contain "hello"
    And the stdout from "ruby -e 'puts :goodbye'" should not contain "hello"

  Scenario: Detect stderr from named source
    When I run `ruby -e 'STDERR.puts :hello'`
    And I run `ruby -e 'puts :goodbye'`
    Then the stderr from "ruby -e 'STDERR.puts :hello'" should contain "hello"
    And the stdout from "ruby -e 'STDERR.puts :hello'" should not contain "hello"
    And the stderr from "ruby -e 'puts :goodbye'" should not contain "hello"

  @wip
  Scenario: Detect output from named source with custom name

  Scenario: Detect second output from named source with custom name
    When I set env variable "ARUBA_TEST_VAR" to "first"
    And I run `ruby -e 'puts ENV[%q(ARUBA_TEST_VAR)]'`
    Then the output from "ruby -e 'puts ENV[%q(ARUBA_TEST_VAR)]'" should contain "first"
    When I set env variable "ARUBA_TEST_VAR" to "second"
    And I run `ruby -e 'puts ENV[%q(ARUBA_TEST_VAR)]'`
    Then the output from "ruby -e 'puts ENV[%q(ARUBA_TEST_VAR)]'" should contain "second"
