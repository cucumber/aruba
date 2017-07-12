Feature: Running an interactive command

  In order to test interactive command line applications
  As a developer using Cucumber
  I want to use the interactive session steps

  Background:
    Given I use a fixture named "cli-app"

  @wip-jruby-java-1.6
  Scenario: Running ruby interactively
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env ruby

    while res = gets.chomp
      break if res == "quit"
      puts res.reverse
    end
    """
    And a file named "features/interactive.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `aruba-test-cli` interactively
        And I type "hello, world"
        And I type "quit"
        Then it should pass with "dlrow ,olleh"
    """
    When I run `cucumber`
    Then the features should all pass

  @posix
  Scenario: Running a native binary interactively
    Given a file named "features/interactive.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
      When I run `cat` interactively
      And I type "Hello, world"
      And I type ""
      Then the output should contain "Hello, world"
    """
    When I run `cucumber`
    Then the features should all pass

  @posix
  Scenario: Pipe in a file
    Given a file named "features/interactive.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        Given a file named "test.txt" with "line1\nline2"
        When I run `cat` interactively
        And I pipe in the file "test.txt"
        Then the output should contain "line1\nline2"
    """
    When I run `cucumber`
    Then the features should all pass

  @posix
  Scenario: Close stdin stream
    Given a file named "features/interactive.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cat` interactively
        And I type "Hello, world"
        And I close the stdin stream
        Then the output should contain "Hello, world"
    """
    When I run `cucumber`
    Then the features should all pass

  @posix
  Scenario: All processes are stopped before checking for filesystem changes

    See: http://github.com/aslakhellesoy/aruba/issues#issue/17 for context

    Given a file named "features/interactive.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        Given a directory named "rename_me"
        When I run `mv rename_me renamed` interactively
        Then the directory "renamed" should exist
        And the directory "rename_me" should not exist
    """
    When I run `cucumber`
    Then the features should all pass
