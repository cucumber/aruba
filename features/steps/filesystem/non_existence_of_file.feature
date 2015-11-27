Feature: Make sure and check a file does not exist

  To setup a working environment, you may want to make sure, that a
  file does not exist or if you ran your command of a file
  was deleted.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Delete existing file
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Non-Existence
      Background:
        Given a file named "example.txt" does not exist

      Scenario: Non-Existence #1
        Then the file "example.txt" should not exist

      Scenario: Non-Existence #2
        Then the file "example.txt" should not exist

      Scenario: Non-Existence #3
        Then the file "example.txt" should not exist
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Check if a file does not exists
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Non-Existence
      Background:
        Given a file named "example.txt" does not exist

      Scenario: Non-Existence #1
        Then the file "example.txt" should not exist

      Scenario: Non-Existence #2
        Then the file named "example.txt" should not exist

      Scenario: Non-Existence #3
        Then a file named "example.txt" should not exist

      Scenario: Non-Existence #4
        Then a file named "example.txt" should not exist anymore

      Scenario: Non-Existence #5
        Then the file named "example.txt" should not exist anymore

      Scenario: Non-Existence #6
        Then the file "example.txt" should not exist anymore
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Check for absence of multiple files
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Non-Existence
      Scenario: Non-Existence
        Given the file "lorem/ipsum/dolor.txt" does not exist
        Given the file "lorem/ipsum/sit.txt" does not exist
        Then the following files should not exist:
          | lorem/ipsum/dolor.txt |
          | lorem/ipsum/sit.txt |
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Check for absence of a single file using a regex
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Existence
      Scenario: Existence
        Given the file "lorem/ipsum/sit.txt" does not exist
        Then a file matching %r<^ipsum> should not exist
    """
    When I run `cucumber`
    Then the features should all pass
