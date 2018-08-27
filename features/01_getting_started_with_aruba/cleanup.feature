Feature: Cleanup Aruba Working Directory

  By default Aruba removes its scratch directory before
  every scenario. This isn't always the right thing
  to do, especially when the path to the default directory
  has been changed. Use @no-clobber to stop Aruba from
  cleaning up after itself.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Clean up artifacts and pwd from a previous scenario
    Given a file named "features/cleanup.feature" with:
    """
    Feature: Check
      Scenario: Check #1
        Given a file named "file.txt" with "content"
        And a directory named "dir.d"
        Then a file named "file.txt" should exist
        And a directory named "dir.d" should exist
        When I cd to "dir.d"
        And I run `pwd`
        Then the output should match %r</tmp/aruba/dir.d$>

      Scenario: Check #2
        Then a file named "file.txt" should not exist
        And a directory named "dir.d" should not exist
        When I run `pwd`
        Then the output should match %r</tmp/aruba$>
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Do not clobber before run
    The `@no-clobber` tag stops Aruba from clearing out its scratch directory.
    Other setup steps are still performed, such as setting the current working
    directory.

    Given a file named "tmp/aruba/file.txt" with "content"
    And a directory named "tmp/aruba/dir.d"
    And a file named "features/cleanup.feature" with:
    """
    Feature: Check
      Scenario: Check #1
        Given a file named "file.txt" with "content"
        And a directory named "dir.d"
        Then a file named "file.txt" should exist
        And a directory named "dir.d" should exist

      @no-clobber
      Scenario: Check #2
        Then a file named "file.txt" should exist
        And a directory named "dir.d" should exist
        When I run `pwd`
        Then the output should match %r</tmp/aruba$>
    """
    When I run `cucumber`
    Then the features should all pass
