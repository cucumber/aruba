Feature: Disable Bundler environment
  Use the @disable-bundler tag to escape from your project's Gemfile.

  @disable-bundler
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
        When I run `bundle`
        Then the output should not contain "aruba"

      @disable-bundler
      Scenario: Run programs that are not in the outer bundle
        Given a file named "Gemfile" with:
        \"\"\"
        source 'https://rubygems.org'

        gem 'rubocop'
        \"\"\"
        When I run `bundle`
        When I run `bundle exec rubocop --help`
        Then the output should contain "Usage: rubocop"
    """
    When I run `bundle`
    When I run `bundle exec cucumber`
    Then the features should all pass

  @disable-bundler
  Scenario: Direct test
    Given I use the fixture "cli-app"
    Given a file named "Gemfile" with:
    """
    source 'https://rubygems.org'

    gem 'parallel_tests'
    """
    When I successfully run `bundle`
    When I successfully run `bundle exec parallel_rspec --help`
    Then the output should contain "Run all tests in parallel"
