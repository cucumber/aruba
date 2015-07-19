Feature: Modify environment variables

  In order to test command line applications which make use of environment variables
  As a developer using Cucumber
  I want to use the command environment variable step

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Change/Set value of arbitrary environment variable
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts ENV['LONG_LONG_VARIABLE']
    """
    And a file named "features/environment_variable.feature" with:
    """
    Feature: Flushing output
      Scenario: Run command
        Given I set the environment variables to:
          | variable           | value      |
          | LONG_LONG_VARIABLE | long_value |
        When I run `cli`
        Then the output should contain "long_value"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Change the HOME-variable of current user during test using custom step
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts File.expand_path('~/')
    """
    And a file named "features/home_directory.feature" with:
    """
    Feature: Run command with different home directory
      Scenario: Run command
        Given a mocked home directory
        When I run `cli`
        Then the output should contain "tmp/aruba"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Change the HOME-variable of current user during test using tag
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts File.expand_path('~/')
    """
    And a file named "features/home_directory.feature" with:
    """
    Feature: Run command
      @mocked_home_directory
      Scenario: Run command
        When I run `cli`
        Then the output should contain "tmp/aruba"
    """
    When I run `cucumber`
    Then the features should all pass
