Feature: Use fixtures in your tests

  Sometimes your tests need existing files to work - e.g binary data files you
  cannot create programmatically. Since `aruba` >= 0.6.3 includes some basic
  support for fixtures. All you need to do is the following:
  
  1. Create a `fixtures`-directory
  2. Create fixture files in this directory
  

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Use a fixture for your tests
    Given a file named "features/fixtures.feature" with:
    """
    Feature: Fixture
      Scenario: Fixture
        Given I use a fixture named "fixtures-app"
        Then a file named "test.txt" should exist
    """
    And a directory named "fixtures"
    And an empty file named "fixtures/fixtures-app/test.txt"
    When I run `cucumber`
    Then the features should all pass

  Scenario: Use a fixture for your tests in test/
    Given a file named "features/fixtures.feature" with:
    """
    Feature: Fixture
      Scenario: Fixture
        Given I use a fixture named "fixtures-app"
        Then a file named "test.txt" should exist
    """
    And a directory named "test/fixtures"
    And an empty file named "test/fixtures/fixtures-app/test.txt"
    When I run `cucumber`
    Then the features should all pass

  Scenario: Use a fixture for your tests in specs/
    Given a file named "features/fixtures.feature" with:
    """
    Feature: Fixture
      Scenario: Fixture
        Given I use a fixture named "fixtures-app"
        Then a file named "test.txt" should exist
    """
    And a directory named "spec/fixtures"
    And an empty file named "spec/fixtures/fixtures-app/test.txt"
    When I run `cucumber`
    Then the features should all pass

  Scenario: Use a fixture for your tests in features/
    Given a file named "features/fixtures.feature" with:
    """
    Feature: Fixture
      Scenario: Fixture
        Given I use a fixture named "fixtures-app"
        Then a file named "test.txt" should exist
    """
    And a directory named "features/fixtures"
    And an empty file named "features/fixtures/fixtures-app/test.txt"
    When I run `cucumber`
    Then the features should all pass
