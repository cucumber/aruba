Feature: Aruba Console

  Background:
    Given a mocked home directory

  @requires-readline
  Scenario: Start console
    Given I run `aruba console` interactively
    When I close the stdin stream
    Then the output should contain:
    """
    aruba:001:0>
    """

  @unsupported-on-platform-java
  @requires-readline
  Scenario: Show help
    Given I run `aruba console` interactively
    And I type "aruba_help"
    When I close the stdin stream
    Then the output should contain:
    """
    Version:
    """
    And the output should contain:
    """
    Issue Tracker:
    """
    And the output should contain:
    """
    Documentation:
    """

  @unsupported-on-platform-java
  @requires-readline
  Scenario: Show methods
    Given I run `aruba console` interactively
    And I type "aruba_methods"
    When I close the stdin stream
    Then the output should contain:
    """
    Methods:
    """
    And the output should contain:
    """
    * setup_aruba
    """

  @unsupported-on-platform-java
  @requires-readline
  Scenario: Has history
    Given I run `aruba console` interactively
    And I type "aruba_methods"
    And I type "exit"
    When I close the stdin stream
    Then the file "~/.aruba_history" should exist
