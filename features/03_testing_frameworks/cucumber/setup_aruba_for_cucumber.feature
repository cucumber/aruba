Feature: Getting started with Cucumber and aruba

  Background:
    Given I use the fixture "empty-app"

  Scenario: Standard Integration

    To use the standard integration just require `aruba/cucumber` in your
    `features/support/env.rb`.

    The standard integration adds some `Before` hooks for you:

    - Set up the temporary Aruba workspace directory
    - Clear environment (ENV)
    - Set HOME-variable from `aruba.home_directory`
    - Activate announcers based on `@announce-<name>`-tags

    It also adds `After` hooks to:

    - Terminate any running commands
    - Clear out the command monitor
    - Tear down the temporary Aruba workspace directory

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

    - `aruba.setup`

    before any method of aruba is used.

    Also, make sure you run

    - `terminate_all_commands`
    - `aruba.command_monitor.clear`
    - `aruba.teardown`

    after each scenario.

    Given a file named "features/support/env.rb" with:
    """
    require 'aruba/api'
    require 'aruba/cucumber/file'
    World(Aruba::Api)

    Before do
      # Make sure you command can be found by "aruba"
      prepend_environment_variable 'PATH', aruba.config.command_search_paths.join(File::PATH_SEPARATOR) + File::PATH_SEPARATOR

      # Mock HOME-directory
      set_environment_variable 'HOME', aruba.home_directory

      aruba.setup
    end

    After do
      terminate_all_commands
      aruba.command_monitor.clear
      aruba.teardown
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
