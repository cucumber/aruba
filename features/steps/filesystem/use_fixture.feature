Feature: Use a fixture

  As a user of aruba
  I want to use a fixture

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Use the fixture if fixtures directory is in root directory
    Given a file named "features/use_fixtures.feature" with:
    """
    Feature: Use Fixture
      Scenario: Use Fixture
        Given I use a fixture named "my-app"
        Then a file named "MY-APP-README.md" should exist
    """
    And a directory named "fixtures"
    And a directory named "fixtures/my-app"
    And an empty file named "fixtures/my-app/MY-APP-README.md"
    When I run `cucumber`
    Then the features should all pass

  Scenario: Use the fixture if fixtures directory is in features-directory
    Given a file named "features/use_fixtures.feature" with:
    """
    Feature: Use Fixture
      Scenario: Use Fixture
        Given I use a fixture named "my-app"
        Then a file named "MY-APP-README.md" should exist
    """
    And a directory named "features/fixtures"
    And a directory named "features/fixtures/my-app"
    And an empty file named "features/fixtures/my-app/MY-APP-README.md"
    When I run `cucumber`
    Then the features should all pass

  Scenario: Use the fixture if fixtures directory is in spec-directory
    Given a file named "features/use_fixtures.feature" with:
    """
    Feature: Use Fixture
      Scenario: Use Fixture
        Given I use a fixture named "my-app"
        Then a file named "MY-APP-README.md" should exist
    """
    And a directory named "spec/fixtures"
    And a directory named "spec/fixtures/my-app"
    And an empty file named "spec/fixtures/my-app/MY-APP-README.md"
    When I run `cucumber`
    Then the features should all pass

  Scenario: Use the fixture if fixtures directory is in test-directory
    Given a file named "features/use_fixtures.feature" with:
    """
    Feature: Use Fixture
      Scenario: Use Fixture
        Given I use a fixture named "my-app"
        Then a file named "MY-APP-README.md" should exist
    """
    And a directory named "test/fixtures"
    And a directory named "test/fixtures/my-app"
    And an empty file named "test/fixtures/my-app/MY-APP-README.md"
    When I run `cucumber`
    Then the features should all pass

  Scenario: Fails if fixture does not exist
    Given a file named "features/use_fixtures.feature" with:
    """
    Feature: Use Fixture
      Scenario: Use Fixture
        Given I use a fixture named "my-app"
    """
    And a directory named "fixtures"
    When I run `cucumber`
    Then the features should not all pass with regex:
    """
    Fixture "my-app" does not exist in fixtures directory ".+/fixtures"
    """
