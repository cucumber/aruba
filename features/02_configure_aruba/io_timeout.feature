Feature: Configure timeout for io of commands

  As a developer
  I want to configure the timeout waiting for io of a command
  In order to support some longer running commands

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      puts %(The default value is "#{config.io_wait_timeout}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "0.1"
    """

  Scenario: Modify value
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      config.io_wait_timeout = 2
    end
    """
    Then I successfully run `cucumber`
