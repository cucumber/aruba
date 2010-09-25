Feature: Interactive

  In order to test interactive command line applications
  As a developer using Cucumber
  I want to use the interactive session steps

  Scenario: Running interactively
    Given a file named "echo.rb" with:
      """
      while res = gets.chomp
        break if res == "quit"
        puts res.reverse
      end
      """
    When I start an interactive session with "ruby echo.rb"
    And I type "hello, world" into the session
    And I stop the session
    Then the session transcript should be:
      """
      hello, world
      dlrow ,olleh
      """

  Scenario: bc
    When I start an interactive session with "bc -q"
    And I type "4 + 3" into the session
    And I type "quit" into the session
    Then the session transcript should be:
      """
      4 + 3
      7
      quit
      """

  Scenario: Plain background process
    When I run "bc -q" interactively with the input:
      """
      4 + 3
      """
    Then the output should be:
      """
      7
      """
