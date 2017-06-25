Feature: Move file or directory

  As a user of aruba
  I want ot move a file or a directory
  To setup my tests

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Move file
    Given a file named "features/move.feature" with:
    """
    Feature: Move
      Scenario: Move
        Given an empty file named "file1.txt"
        And an empty file named "file2.txt"
        And an empty file named "file3.txt"
        When I move a file named "file1.txt" to "new_file1.txt"
        When I move a file from "file2.txt" to "new_file2.txt"
        When I move the file "file3.txt" to "new_file3.txt"
        Then a file named "new_file1.txt" should exist
        Then a file named "new_file2.txt" should exist
        Then a file named "new_file3.txt" should exist
    """
    When I run `cucumber`
    Then the features should all pass
