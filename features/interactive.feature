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

  Scenario: session table
    When I start an interactive session with "ruby echo.rb"
    And I quit the session with "quit"
    Then the session transcript should look like this:
      | input | output |
      | hello | olleh  |
