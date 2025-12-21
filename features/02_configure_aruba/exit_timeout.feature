Feature: Configure timeout for command execution

  As a developer
  I want to configure the timeout when executing a command
  In order to support some longer running commands

  Note that on Windows, you must check for timeouts explicitly and cannot rely
  on a nonzero exit status: Killing the process from Ruby when the timeout
  occurs will set the exit status to 0.

  Background:
    Given I use the fixture "cli-app"
    And an executable named "bin/aruba-test-cli" with:
    """ruby
    #!/usr/bin/env ruby
    sleep ARGV[0].to_f
    """
    And a file named "features/step_definitions/timeout_steps.rb" with:
    """ruby
    Then 'the command should finish in time' do
      expect(last_command_started).to have_finished_in_time
    end
    """

  Scenario: Default value
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      puts %(The default value is "#{config.exit_timeout}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "15"
    """

  Scenario: Modify value
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      config.exit_timeout = 1.0
    end
    """
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Fast command
        When I run `aruba-test-cli 0.5`
        Then the command should finish in time
    """
    Then I successfully run `cucumber`

  Scenario: Fails if takes longer
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      config.exit_timeout = 0.5
    end
    """
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Fast command
        When I run `aruba-test-cli 2.5`
        Then the command should finish in time
    """
    Then I run `cucumber`
    And the exit status should be 1
