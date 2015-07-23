Feature: Create Directory

  As a user of aruba
  I want to create directories

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Non-existing directory
    Given a file named "features/create_directory.feature" with:
    """
    Feature: Create directory
      Scenario: Create directory
        Given a directory named "dir1"
        Given the directory "dir2"
        Given the directory named "dir3"
        Then a directory named "dir1" should exist
        And a directory named "dir2" should exist
        And a directory named "dir3" should exist
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Existing directory

    It doesn't matter if a directory already exist.

    Given a file named "features/create_directory.feature" with:
    """
    Feature: Create directory
      Scenario: Create directory
        Given a directory named "dir1"
        And a directory named "dir1"
    """
    When I run `cucumber`
    Then the features should all pass
