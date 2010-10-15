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

  @wip
  Scenario: Filesystem checks
    See: http://github.com/aslakhellesoy/aruba/issues#issue/17 for context

    Given a directory named "rename_me"
    When I run "mv rename_me renamed" interactively
    And sleep 1
    Then the following directories should exist:
      | renamed |
    And the following directories should not exist:
      | rename_me |
