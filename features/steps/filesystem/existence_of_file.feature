Feature: Make sure and check a file exists

  To setup a working environment, you may want to make sure, that a
  file exist or if you ran your command of a file
  was deleted.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Check for presence of a single file
    Given an empty file named "lorem/ipsum/dolor"
    Then a file named "lorem/ipsum/dolor" should exist

  Scenario: Check for presence of a subset of files
    Given a file named "features/existence.feature" with:
    """
    Feature: Existence
      Scenario: Existence
        Given an empty file named "lorem/ipsum/dolor"
        And an empty file named "lorem/ipsum/sit"
        And an empty file named "lorem/ipsum/amet"
        Then the following files should exist:
          | lorem/ipsum/dolor |
          | lorem/ipsum/amet  |
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Check for presence of a single file using a regex
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Existence
      Background:
        Given an empty file named "lorem/ipsum/dolor"

      Scenario: Existence #1
        Then a file matching %r<dolor$> should exist

      Scenario: Existence #2
        Then a file matching %r<ipsum/dolor> should exist
    """
    When I run `cucumber`
    Then the features should all pass
