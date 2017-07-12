Feature: Configure announcer activation on command failure

  As a developer
  I want to configure which announcers should get activated on command failure
  In order to understand what caused a command to fail

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      puts %(The default value is "#{config.activate_announcer_on_command_failure.inspect}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """ruby
    The default value is "[]"
    """

  Scenario: Modify value
    Given a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      config.activate_announcer_on_command_failure = [:foo, :bar]
    end

    Aruba.configure do |config|
      puts %(The value is "#{config.activate_announcer_on_command_failure.inspect}")
    end
    """
    Then I successfully run `cucumber`
    Then the output should contain:
    """
    The value is "[:foo, :bar]"
    """
