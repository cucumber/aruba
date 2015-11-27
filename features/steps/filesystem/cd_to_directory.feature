Feature: Change working directory

  You might want to change the current working directory.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Change to an existing sub directory
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Working Directory
      Scenario: Working Directory
        Given a file named "foo/bar/example.txt" with:
        \"\"\"
        hello world
        \"\"\"
        When I cd to "foo/bar"
        And I run `cat example.txt`
        Then the output should contain "hello world"
        And the file "example.txt" should exist
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Change to an non-existing sub directory
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Working Directory
      Scenario: Working Directory
        When I cd to "foo/bar/non-existing"
    """
    When I run `cucumber`
    Then the features should not pass
