Feature: Remove a directory

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Remove an existing directory
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Remove
      Scenario: Remove
        Given an empty directory named "foo"
        When I remove the directory "foo"
        Then the directory "foo" should not exist
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Remove an non-existing directory
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Remove
      Scenario: Remove
        When I remove the directory "foo"
        Then the directory "foo" should not exist
    """
    When I run `cucumber`
    Then the features should not pass

  Scenario: Force remove an non-existing directory
    Given a file named "features/non-existence.feature" with:
    """
    Feature: Remove
      Scenario: Remove
        When I remove the directory "foo" with full force
        Then the directory "foo" should not exist
    """
    When I run `cucumber`
    Then the features should all pass
