Feature: Remove a file

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Remove an existing file
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Remove
      Scenario: Remove
        Given an empty file named "foo"
        When I remove the file "foo"
        Then the file "foo" should not exist
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Remove an non-existing file
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Remove
      Scenario: Remove
        When I remove the file "foo"
        Then the file "foo" should not exist
    """
    When I run `cucumber`
    Then the features should not pass

  Scenario: Force remove an non-existing file
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Remove
      Scenario: Remove
        When I remove the file "foo" with full force
        Then the file "foo" should not exist
    """
    When I run `cucumber`
    Then the features should all pass
