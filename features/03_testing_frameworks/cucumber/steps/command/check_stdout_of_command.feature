Feature: STDOUT of commands which were executed

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the stdout should contain" step

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Detect inline subset of stdout
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `echo hello world`
        Then the stdout should contain "hello"
        And the stderr should not contain "hello"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect subset of stdout with multiline string
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `ruby -e 'puts "hello\nworld"; warn "good-bye"'`
        Then the stdout should contain:
        \"\"\"
        hello
        \"\"\"
        And the stdout should not contain:
        \"\"\"
        good-bye
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect exact multiline stdout
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `ruby -e 'puts "hello\nworld"; warn "good-bye"'`
        Then the stdout should contain exactly:
        \"\"\"
        hello
        world
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect combined stdout from normal and interactive processes
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/usr/bin/env ruby

    while input = gets do
      break if "" == input
      puts input
      warn input
    end
    """
    And a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `echo hello`
        When I run `aruba-test-cli` interactively
        And I type "good-bye"
        And I type ""
        Then the stdout should contain exactly:
        \"\"\"
        hello
        good-bye
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect stdout from named source
    Given a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `echo hello`
        And I run `echo good-bye`
        Then the stdout from "echo hello" should contain "hello"
        And the stdout from "echo good-bye" should contain exactly "good-bye"
        And the stdout from "echo hello" should contain exactly:
        \"\"\"
        hello
        \"\"\"
        And the stderr should not contain anything
    """
    When I run `cucumber`
    Then the features should all pass
