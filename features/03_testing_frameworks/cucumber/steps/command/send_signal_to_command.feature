Feature: Send a signal to command

  You can send a command a signal with the following steps:

  - `When I send the signal "HUP" to the command started last`
  - `When I send the signal "HUP" to the command "bin/aruba-test-cli"`

  Or just use `kill` on compatible platforms.

  Background:
    Given I use a fixture named "cli-app"
    And an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash
    function hup {
      echo "Got signal HUP."
      exit 0
    }

    trap hup HUP
    while [ true ]; do sleep 0.1; done
    """
    And a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      config.startup_wait_time = 0.1
      config.exit_timeout = 0.2
    end
    """

  Scenario: Sending signal to the command started last
    Given a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Run command
        When I run `aruba-test-cli` in background
        And I send the signal "HUP" to the command started last
        Then the exit status should be 0
        And the output should contain:
        \"\"\"
        Got signal HUP.
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Sending signal to a command given by command line
    Given a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Run command
        When I run `aruba-test-cli` in background
        And I send the signal "HUP" to the command "aruba-test-cli"
        Then the exit status should be 0
        And the output should contain:
        \"\"\"
        Got signal HUP.
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  @unsupported-on-platform-windows
  @experimental
  Scenario: Using the "kill"-command

    `<pid-last-command-started>` in your command line will be replaced by the
    PID of the last command started. Please note, this feature is experimental.
    The name of the variable may change without further notice.

    Given a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Run command
        When I run `aruba-test-cli` in background
        And I run `kill -HUP <pid-last-command-started>`
        Then the output should contain:
        \"\"\"
        Got signal HUP.
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass
