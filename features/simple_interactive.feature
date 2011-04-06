Feature: Execute a simple interactive proccess

  In order to test interactive command line applications
  As a developer using Cucumber
  I want to use the interactive session steps on fixture/simple

  @announce
  Scenario: Running a simple script interactively
    When I run a simple fixture interactively  
    Then the output should contain:
    """
    what is your name?
    """
    And I type "Curtis"
    Then the output should contain:
    """
    welcome to the mainframe Curtis
    """

