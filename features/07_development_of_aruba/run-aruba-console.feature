Feature: Running the interactive "aruba" developer console

  As a contributor of aruba
  I want to use the interactive aruba console
  In order to try out the "aruba" api

  @requires-readline
  Scenario: Running aruba interactively

    This starts a pry console with "aruba"'s api loaded.

    When I run `bin/console` interactively
    And I type "exit"
    Then the exit status should be 0
