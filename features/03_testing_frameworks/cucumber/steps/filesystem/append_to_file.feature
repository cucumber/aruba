Feature: Append content to file

  You might want to append some content to an existing file.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Append to an existing file
    Given a file named "features/appending.feature" with:
    """
    Feature: Existence
      Scenario: Existence
        Given a file named "foo/bar/example.txt" with:
        \"\"\"
        hello world
        \"\"\"
        When I append to "foo/bar/example.txt" with:
        \"\"\"
        this was appended
        \"\"\"
        Then the file named "foo/bar/example.txt" should contain:
        \"\"\"
        hello worldthis was appended
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Append whole lines to an existing file
    Given a file named "features/appending.feature" with:
    """
    Feature: Existence
      Scenario: Existence
        Given a file named "foo/bar/example.txt" with:
        \"\"\"
        hello world
        \"\"\"
        When I append the following lines to "foo/bar/example.txt":
        \"\"\"
        this was appended
        \"\"\"
        Then the file named "foo/bar/example.txt" should contain:
        \"\"\"
        hello world
        this was appended
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Append to a non-existing file (deprecated)
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Existence
      Scenario: Existence
        Given a file named "foo/bar/example.txt" does not exist
        When I append to "foo/bar/example.txt" with:
        \"\"\"
        this was appended
        \"\"\"
        Then the file named "foo/bar/example.txt" should contain:
        \"\"\"
        this was appended
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    The ability to call #append_to_file with a file that does not exist is deprecated
    """
