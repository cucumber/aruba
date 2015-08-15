Feature: Copy file or directory

  As a user of aruba
  I want ot copy a file or a directory
  To setup my tests

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Copy file
    Given a file named "features/copy.feature" with:
    """
    Feature: Copy
      Scenario: Copy
        Given an empty file named "file1.txt"
        And an empty file named "file2.txt"
        And an empty file named "file3.txt"
        When I copy a file named "file1.txt" to "new_file1.txt"
        When I copy a file from "file2.txt" to "new_file2.txt"
        When I copy the file "file3.txt" to "new_file3.txt"
        Then a file named "new_file1.txt" should exist
        Then a file named "new_file2.txt" should exist
        Then a file named "new_file3.txt" should exist
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Copy directory
    Given a file named "features/copy.feature" with:
    """
    Feature: Copy
      Scenario: Copy
        Given a directory named "dir1.d"
        And a directory named "dir2.d"
        And a directory named "dir3.d"
        When I copy a directory named "dir1.d" to "new_dir1.d"
        When I copy a directory from "dir2.d" to "new_dir2.d"
        When I copy the directory "dir3.d" to "new_dir3.d"
        Then a directory named "new_dir1.d" should exist
        Then a directory named "new_dir2.d" should exist
        Then a directory named "new_dir3.d" should exist
    """
    When I run `cucumber`
    Then the features should all pass

