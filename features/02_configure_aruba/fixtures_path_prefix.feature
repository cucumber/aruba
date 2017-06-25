Feature: Use fixtures path prefix of aruba

  As a developer
  I want to use the fixtures path prefix in aruba
  In some API-method for using the fixtures path

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      puts "The prefix is \"#{config.fixtures_path_prefix}\"."
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The prefix is "%".
    """


