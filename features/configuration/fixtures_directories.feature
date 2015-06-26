Feature: Configure directory where to look for fixtures

  As a developer
  I want to configure the directory where aruba looks for fixtures
  In order to use them in my tests

  Background:
    Given I use the fixture "cli-app"
    And the default feature-test

  Scenario: Default value
    Given a file named "features/support/aruba.rb" with:
    """
    Aruba.configure do |config|
      puts %(The default value is "%w(#{config.fixtures_directories.join(" ")})")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "%w(features/fixtures spec/fixtures test/fixtures)"
    """

  Scenario: Modify value
    Given a file named "features/support/aruba.rb" with:
    """
    Aruba.configure do |config|
      config.fixtures_directories = %w(spec/fixtures)
    end
    """
    When I successfully run `cucumber`
