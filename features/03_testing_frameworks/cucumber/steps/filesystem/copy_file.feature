Feature: Copy file or directory

  As a user of aruba
  I want ot copy a file or a directory
  To setup my tests

  Background:
    Given I use a fixture named "cli-app"

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

