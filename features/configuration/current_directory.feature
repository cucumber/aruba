Feature: Configure current directory of aruba

  As a developer
  I want to configure the current directory of aruba
  In order to have a test directory for each used spec runner - e.g. cucumber or rspec

  Background:
    Given I use the fixture "cli-app"
    And the default feature-test

  Scenario: Default value
    Given a file named "features/support/aruba.rb" with:
    """
    Aruba.configure do |config|
      puts %(The default value is "%w(#{config.current_directory.join(" ")})")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "%w(tmp aruba)"
    """

  Scenario: Modify value
    Given a file named "features/support/aruba.rb" with:
    """
    Aruba.configure do |config|
      config.current_directory = %w(tmp cucumber)
    end
    """
    When I successfully run `cucumber`
    Then a directory named "tmp/cucumber" should exist
