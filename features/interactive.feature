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
    Then the directory "renamed" should exist
    And the directory "rename_me" should not exist
