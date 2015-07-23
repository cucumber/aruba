Feature: Configure if ansi color codes should be stripped off from command output (deprecated)

  As a developer
  I want to strip off ansi color codes
  In order to make checking of those outputs easier

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      puts %(The default value is "#{config.keep_ansi}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "false"
    """

  Scenario: Modify value
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      config.keep_ansi = true
    end
    """
    Then I successfully run `cucumber`
