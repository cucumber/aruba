Feature: Disable Bundler environment
  Use the @disable-bundler tag to escape from your project's Gemfile.

  Scenario: Clear the Bundler environment
    Given I use the fixture "cli-app"
    Given a file named "features/run.feature" with:
    """
    Feature: My Feature
      @disable-bundler
      Scenario: Check environment
        When I run `env`
        Then the output should not match /^BUNDLE_GEMFILE=/

      @disable-bundler
      Scenario: Run bundle in a fresh bundler environment
        Given a file named "Gemfile" with:
        \"\"\"
        source 'https://rubygems.org'
        \"\"\"
        When I run `bundle --local`
        Then the output should not contain "aruba"

      Scenario: Run bundle in the existing bundler environment
        Given a file named "Gemfile" with:
        \"\"\"
        source 'https://rubygems.org'
        \"\"\"
        When I run `bundle --local`
        Then the output should contain "aruba"
    """
    When I run `bundle exec cucumber`
    Then the features should all pass
