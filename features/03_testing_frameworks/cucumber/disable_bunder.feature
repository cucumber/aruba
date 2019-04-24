Feature: Disable Bundler environment
  Use the @disable-bundler tag to escape from your project's Gemfile.

  Background:
    Given I use the fixture "cli-app"

  Scenario: Clear the Bundler environment

    Given a file named "features/run.feature" with:
    """
    Feature: My Feature
      @disable-bundler
      Scenario: Check environment
        When I run `env`
        Then the output should not match /^BUNDLE_GEMFILE=/
    """
    When I run `cucumber`
    Then the features should all pass
