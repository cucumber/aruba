Feature: Cleanup Aruba Working Directory

  By default Aruba removes its scratch directory before
  every scenario. This isn't always the right thing
  to do, especially when the path to the default directory
  has been changed. Use @no-clobber to stop Aruba from
  cleaning up after itself.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Changes in the filesystem
    Given a file named "tmp/aruba/file.txt" with "content"
    And a directory named "tmp/aruba/dir.d"
    And a file named "features/flushing.feature" with:
    """
    Feature: Check
      Scenario: Check
        Then a file named "file.txt" does not exist
        And a directory named "dir.d" does not exist
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Do not clobber before run
    Given a file named "tmp/aruba/file.txt" with "content"
    And a directory named "tmp/aruba/dir.d"
    And a file named "features/flushing.feature" with:
    """
    Feature: Check
      @no-clobber
      Scenario: Check
        Then a file named "file.txt" should exist
        And a directory named "dir.d" should exist
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Cleanup and verify the previous scenario
    Given a file named "features/flushing.feature" with:
    """
    Feature: Check
      Scenario: Check #1
        Given a file named "tmp/aruba/file.txt" with "content"
        And a directory named "tmp/aruba/dir.d"

      Scenario: Check #2
        Then a file named "file.txt" should not exist
        And a directory named "dir.d" should not exist
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario:  Current directory from previous scenario is reseted
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Reset
      Scenario: Reset #1
        Given a directory named "dir1"
        When I cd to "dir1"

      Scenario: Reset #2
        When I run `pwd`
        Then the output should match %r</tmp/aruba$>
    """
    When I run `cucumber`
    Then the features should all pass
