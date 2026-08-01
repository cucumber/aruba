Feature: Cleanup Aruba Working Directory

  Aruba removes its scratch directory *before* every scenario.

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
