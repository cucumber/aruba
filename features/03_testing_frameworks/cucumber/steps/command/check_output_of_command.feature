Feature: All output of commands which were executed

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the output should contain" step

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Detect inline subset of output
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `echo hello world`
        Then the output should contain "hello world"
        And the output should not contain "good-bye"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect subset of output with multiline string
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `ruby -e 'puts "hello\nworld"'`
        Then the output should contain:
        \"\"\"
        hello
        \"\"\"
        And the output should not contain:
        \"\"\"
        good-bye
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect exact multiline output
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `ruby -e 'puts "hello\nworld"; warn "good-bye"'`
        Then the output should contain exactly:
        \"\"\"
        hello
        world
        good-bye
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect combined output from normal and interactive processes
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/usr/bin/env ruby

    while input = gets do
      break if "" == input
      puts input
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

  Scenario: Detect output from named source
    Given a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `echo hello`
        And I run `echo good-bye`
        Then the output from "echo hello" should contain "hello"
        And the output from "echo good-bye" should contain exactly "good-bye"
        And the output from "echo hello" should contain exactly:
        \"\"\"
        hello
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect exact output with ANSI output
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      @keep-ansi-escape-sequences
      Scenario: Run command
        When I run `ruby -e 'puts "\e[36mhello world\e[0m"'`
        Then the output should contain exactly:
        \"\"\"
        \e[36mhello world\e[0m
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect exact output with ANSI output stripped by default
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `ruby -e 'puts "\e[36mhello world\e[0m"'`
        Then the output should contain exactly:
        \"\"\"
        hello world
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect subset of one-line output with regex
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `echo hello, ruby`
        Then the output should match /^hello(, world)?/
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect subset of multiline output with regex
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `ruby -e 'puts "hello\nworld\nextra line1\nextra line2\nimportant line"'`
        Then the output should match:
        \"\"\"
        he..o
        wor.d
        .*
        important line
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Negative matching of one-line output with regex
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `echo hello, ruby`
        Then the output should not match /ruby is a better perl$/
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Negative matching of multiline output with regex
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `ruby -e 'puts "hello\nworld\nextra line1\nextra line2\nimportant line"'`
        Then the output should not match:
        \"\"\"
        ruby
        is
        a
        .*
        perl
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Check size of output
    Given a file named "features/flushing.feature" with:
    """cucumber
    Feature: Flushing output
      Scenario: Run command
        When I run `echo 1234567890`
        Then the output should be 11 bytes long
    """
    When I run `cucumber`
    Then the features should all pass
