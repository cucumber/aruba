Feature: Compare files

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Compare existing files
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Existence
      Scenario: Existence
        Given a file named "foo" with:
        \"\"\"
        hello world
        \"\"\"
        And a file named "bar" with:
        \"\"\"
        hello world
        \"\"\"
        And a file named "nonbar" with:
        \"\"\"
        hello another world
        \"\"\"
        Then the file "foo" should be equal to file "bar"
        And the file "foo" should not be equal to file "nonbar"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Compare non-existing files
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Existence
      Scenario: Existence
        Given a file named "foo" with:
        \"\"\"
        hello world
        \"\"\"
        Then the file "foo" should be equal to file "bar"
    """
    When I run `cucumber`
    Then the features should not pass

