Feature: Append content to file

  You might want to append some content to a file.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Append to a existing file
    Given a file named "features/non-existence.feature" with:
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

  Scenario: Append to a non-existing file
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
