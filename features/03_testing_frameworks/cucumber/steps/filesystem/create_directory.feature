Feature: Create Directory

  As a user of aruba
  I want to create directories

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Non-existing directory
    Given a file named "features/create_directory.feature" with:
    """
    Feature: Create directory
      Background:
        Given a directory named "dir1"

      Scenario: Create directory #1
        Then a directory named "dir1" should exist

      Scenario: Create directory #2
        Then a directory named "dir1" should exist

      Scenario: Create directory #3
        Then a directory named "dir1" should exist

      Scenario: Create directory #4
        Then a directory named "dir1" should exist

      Scenario: Create directory #5
        Then a directory named "dir1" should exist
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

  Scenario: Change mode a long with creation of directory
    Given a file named "features/create_directory.feature" with:
    """
    Feature: Create directory
      Scenario: Create directory
        Given a directory named "dir1" with mode "0644"
        Then the directory named "dir1" should have permissions "0644"
    """
    When I run `cucumber`
    Then the features should all pass
