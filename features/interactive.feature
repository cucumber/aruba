Feature: Interactive process control

  In order to test interactive command line applications
  As a developer using Cucumber
  I want to use the interactive session steps

  Scenario: Running ruby interactively
    Given a file named "echo.rb" with:
      """
      while res = gets.chomp
        break if res == "quit"
        puts res.reverse
      end
      """
    When I run "ruby echo.rb" interactively
    And I type "hello, world"
    And I type "quit"
    Then the output should contain:
      """
      dlrow ,olleh
      """

  Scenario: Running a native binary interactively
    When I run "bc -q" interactively
    And I type "4 + 3"
    And I type "quit"
    Then the output should contain:
      """
      7
      """
