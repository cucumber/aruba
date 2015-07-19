Feature: Configure working directory of aruba

  As a developer
  I want to configure the working directory of aruba
  In order to have a test directory for each used spec runner - e.g. cucumber or rspec

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba.rb" with:
    """
    Aruba.configure do |config|
      puts %(The default value is "#{config.working_directory}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "tmp/aruba"
    """

  Scenario: Modify value
    Given a file named "features/support/aruba.rb" with:
    """
    Aruba.configure do |config|
      config.working_directory = 'tmp/cucumber'
    end
    """
    And the default feature-test
    And the default executable
    When I successfully run `cucumber`
    Then a directory named "tmp/cucumber" should exist
