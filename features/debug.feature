Feature: Debug command execution

  As a developer
  I want to use some debugger in my code and therefor need system() to execute my program
  In order to find a bug

  @debug
  Scenario: Run program with debug code
    When I run `true`
    Then the exit status should be 0

  @debug
  Scenario: Run failing program with debug code
    When I run `false`
    Then the exit status should be 1
