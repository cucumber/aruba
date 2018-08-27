Feature: Make sure and check a directory does not exist

  To setup a working environment, you may want to make sure, that a
  directory does not exist or if you ran your command of a directory
  was deleted.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Delete existing directory
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Non-Existence
      Background:
        Given a directory named "example.d" does not exist

      Scenario: Non-Existence #1
        Then the directory "example.d" should not exist

      Scenario: Non-Existence #2
        Then the directory "example.d" should not exist

      Scenario: Non-Existence #3
        Then the directory "example.d" should not exist
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Check if a directory does not exists
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Non-Existence
      Background:
        Given a directory named "example.d" does not exist

      Scenario: Non-Existence #1
        Then the directory "example.d" should not exist

      Scenario: Non-Existence #2
        Then the directory named "example.d" should not exist

      Scenario: Non-Existence #3
        Then a directory named "example.d" should not exist

      Scenario: Non-Existence #4
        Then a directory named "example.d" should not exist anymore

      Scenario: Non-Existence #5
        Then the directory named "example.d" should not exist anymore

      Scenario: Non-Existence #6
        Then the directory "example.d" should not exist anymore
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Check for absence of a subset of directories
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Non-Existence
      Scenario: Non-Existence
        Given the directory "lorem/ipsum/dolor" does not exist
        And the directory "lorem/ipsum/amet" does not exist
        Then the following directories should not exist:
          | lorem/ipsum/dolor |
          | lorem/ipsum/amet  |
    """
    When I run `cucumber`
    Then the features should all pass
