Feature: Use fixtures in your tests

  If you have more complicated requirements at your test setup, you can use
  fixtures with `aruba`.

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
