Feature: Configure current directory of aruba

  As a developer
  I want to configure the current directory of aruba
  In order to have a test directory for each used spec runner - e.g. cucumber or rspec

  @wip
  Scenario: Default configuration
    Given I use a fixture named "cli-app"
    And a file named "features/support/aruba.rb" with:
    """
    Aruba.configure do |config|
      config.current_directory = File.join('tmp', 'cucumber')
    end
    """
    When I successfully run `cucumber`
    Then a directory named "tmp/cucumber" should exist


