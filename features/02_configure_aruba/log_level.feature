Feature: Configure Log level of aruba logger

  As a developer
  I want to configure the level of information put to output by logger
  In order to modify the amount of information

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      puts %(The default value is "#{config.log_level}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """ruby
    The default value is "info"
    """

  Scenario: Modify value
    Given a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      config.log_level = :warn
    end

    Aruba.configure do |config|
      puts %(The default value is "#{config.log_level}")
    end
    """
    Then I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "warn"
    """
