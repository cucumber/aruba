Feature: Interactive process control

  In order to test interactive command line applications
  As a developer using Cucumber
  I want to use the interactive session steps

  @wip-jruby-java-1.6
  Scenario: Running ruby interactively
    Given a file named "echo.rb" with:
      """
      while res = gets.chomp
        break if res == "quit"
        puts res.reverse
      end
      """
    When I run `ruby echo.rb` interactively
    And I type "hello, world"
    And I type "quit"
    Then it should pass with:
      """
      dlrow ,olleh
      """

  @posix
  Scenario: Running a native binary interactively
    When I run `cat` interactively
    And I type "Hello, world"
    And I type ""
    Then the output should contain:
      """
      Hello, world
      """

  @posix
  Scenario: Pipe in a file
    Given a file named "test.txt" with:
      """
      line1
      line2
      """
    When I run `cat` interactively
    And I pipe in the file "test.txt"
    Then the output should contain:
      """
      line1
      line2
      """

  @posix
  Scenario: Close stdin stream
    When I run `cat` interactively
    And I type "Hello, world"
    And I close the stdin stream
    Then the output should contain:
      """
      Hello, world
      """

  @posix
  Scenario: Stop processes before checking for filesystem changes 
    See: http://github.com/aslakhellesoy/aruba/issues#issue/17 for context

    Given a directory named "rename_me"
    When I run `mv rename_me renamed` interactively
    Then a directory named "renamed" should exist
    And a directory named "rename_me" should not exist

  Scenario: Running another native binary interactively
    When I run `cat` interactively
    And I type "cat a"
    And I type ""
    When I run `cat` interactively
    And I type "cat b"
    And I type ""
    Then the output should contain:
      """
      cat a
      cat b
      """

  @announce
  Scenario: Run two commands at the same time
    When I run `cat` interactively as "cata"
    And I type "cat a" to "cata"
    And I type "\C-D" to "cata"
    When I wait for output to contain "cat a" from "cata"
    When I run `cat` interactively as "catb"
    And I type "cat b" to "catb"
    When I wait for output to contain "cat b" from "catb"
    And I type "\C-D" to "catb"

  @announce
  Scenario: Run two commands at the same time with interleaved steps
    When I run `cat` interactively as "cata"
    When I run `cat` interactively as "catb"
    And I type "cat a" to "cata"
    And I type "cat b" to "catb"
    When I wait for output to contain "cat a" from "cata"
    When I wait for output to contain "cat b" from "catb"
    And I type "\C-D" to "cata"
    And I type "\C-D" to "catb"
