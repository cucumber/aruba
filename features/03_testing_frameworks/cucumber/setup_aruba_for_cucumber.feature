Feature: Getting started with Cucumber and aruba

  Background:
    Given I use the fixture "empty-app"

  Scenario: Simple Integration

    To use the simple integration just require `aruba/cucumber` in your
    `features/support/env.rb`.

    The simple integration adds some `Before`-hooks for you:

      \* Setup Aruba Test directory
      \* Clear environment (ENV)
      \* Make HOME-variable configurable via `aruba.config.home_directory`
      \* Activate announcers based on `@announce-<name>`-tags

    Given a file named "features/support/env.rb" with:
    """
    require 'aruba/cucumber'
    """
    And a file named "features/use_aruba_with_cucumber.feature" with:
    """
    Feature: Cucumber
      Scenario: First Run
        Given a file named "file.txt" with:
        \"\"\"
        Hello World
        \"\"\"
        Then the file "file.txt" should contain:
        \"\"\"
        Hello World
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Custom Integration

    There might be some use cases where you want to build an aruba integration
    of your own. You need to include the API and make sure, that you run

      \* `setup_aruba`
      \* `terminate_all_commands`

    before any method of aruba is used.

    Given a file named "features/support/env.rb" with:
    """
    require 'aruba/api'
    require 'aruba/cucumber/file'
    World(Aruba::Api)

    Before do
      # Make sure you command can be found by "aruba"
      prepend_environment_variable 'PATH', aruba.config.command_search_paths.join(File::PATH_SEPARATOR) + File::PATH_SEPARATOR

      # Mock HOME-directory
      set_environment_variable 'HOME', aruba.config.home_directory
    end

    # Make sure you command can be found by "aruba"
    After do
      terminate_all_commands
      aruba.command_monitor.clear
    end

    # Clean up
    Before('~@no-clobber') do
      setup_aruba
    end
    """
    And a file named "features/use_aruba_with_cucumber.feature" with:
    """
    Feature: Cucumber
      Scenario: First Run
        Given a file named "file.txt" with:
        \"\"\"
        Hello World
        \"\"\"
        Then the file "file.txt" should contain:
        \"\"\"
        Hello World
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass
