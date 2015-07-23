Feature: Create new File

  As a user of aruba
  I want to create files

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Create empty file
    Given a file named "features/create_file.feature" with:
    """
    Feature: Create file
      Scenario: Create file
        Given an empty file named "file1.txt"
        Then a file named "file1.txt" should exist
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Create file with content
    Given a file named "features/create_file.feature" with:
    """
    Feature: Create file
      Scenario: Create file
        Given a file named "file1.txt" with:
        \"\"\"
        Hello World
        \"\"\"
        Then the file named "file1.txt" should contain:
        \"\"\"
        Hello World
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass
