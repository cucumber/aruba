Feature: Make sure and check a directory exists

  To setup a working environment, you may want to make sure, that a
  directory exist.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Check for presence of a single directory
    Given a file named "features/existence.feature" with:
    """
    Feature: Existence
      Background:
        Given an empty directory "lorem/ipsum/dolor"

      Scenario: Existence #1
        Then the directory "lorem/ipsum/dolor" should exist

      Scenario: Existence #2
        Then the directory named "lorem/ipsum/dolor" should exist

      Scenario: Existence #3
        Then a directory named "lorem/ipsum/dolor" should exist
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Check for presence of a multiple directories
    Given a file named "features/existence.feature" with:
    """
    Feature: Existence
      Scenario: Existence
        Given an empty directory "lorem/ipsum/dolor"
        And an empty directory "lorem/ipsum/amet"
        Then the following directories should exist:
          | lorem/ipsum/dolor |
          | lorem/ipsum/amet  |
    """
    When I run `cucumber`
    Then the features should all pass


  Scenario: Check for presence of a subset of directories
    Given a file named "features/existence.feature" with:
    """
    Feature: Existence
      Scenario: Existence
        Given an empty directory "lorem/ipsum/dolor"
        And an empty directory "lorem/ipsum/amet"
        And an empty directory "lorem/ipsum/sit"
        Then the following directories should exist:
          | lorem/ipsum/dolor |
          | lorem/ipsum/amet  |
    """
    When I run `cucumber`
    Then the features should all pass

