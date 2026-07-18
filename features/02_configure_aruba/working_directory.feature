Feature: Configure working directory of aruba

  As a developer
  I want to configure the working directory of aruba
  In order to have a test directory for each used spec runner - e.g. cucumber or rspec

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba_config.rb" with:
    """
    Aruba.configure do |config|
      puts %(The working directory suffix is "#{config.working_directory_suffix}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The working directory suffix is "aruba"
    """

  Scenario: Modify value
    Given a file named "features/support/aruba_config.rb" with:
    """
    Aruba.configure do |config|
      config.working_directory_suffix = 'cucumber'
    end
    """
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Fast command
        When I run `echo "Hello"`
        Then the exit status should be 0
    """
    When I successfully run `cucumber`
    Then a directory named "tmp/cucumber" should exist
