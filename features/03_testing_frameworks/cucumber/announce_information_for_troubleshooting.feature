Feature: Announce output during test run

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the output should contain" step

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Announce change of directory
    Given a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-directory
      Scenario: Run command
        Given a directory named "dir.d"
        When I cd to "dir.d"
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should match %r<\$ cd .*tmp/aruba/dir.d>

  Scenario: Announce stdout
    Given a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-stdout
      Scenario: Run command
        When I run `echo 'Hello World'`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    <<-STDOUT
    Hello World

    STDOUT
    """

  @requires-ruby
  Scenario: Announce stderr
    Given a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-stderr
      Scenario: Run command
        When I run `ruby -e "warn 'Hello World'"`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    <<-STDERR
    Hello World

    STDERR
    """

  @requires-ruby
  Scenario: Announce both stderr and stdout
    Given a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-output
      Scenario: Run command
        When I run `ruby -e "warn 'Hello'; puts 'World'"`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    <<-STDERR
    Hello

    STDERR
    """
    And the output should contain:
    """
    <<-STDOUT
    World

    STDOUT
    """

  Scenario: Announce command
    Given a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-command
      Scenario: Run command
        When I run `aruba-test-cli`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    $ aruba-test-cli
    """

  Scenario: Announce change of environment variable
    Given a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-changed-environment
      Scenario: Run command
        When I set the environment variables to:
          | variable | value    |
          | MY_VAR   | my_value |
        And I run `aruba-test-cli`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    $ export MY_VAR=my_value
    """

  Scenario: Announce change of environment variable which contains special characters
    Given a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-changed-environment
      Scenario: Run command
        When I set the environment variables to:
          | variable | value      |
          | MY_VAR   | my value ! |
        And I run `aruba-test-cli`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    $ export MY_VAR=my\ value\ \
    """

  Scenario: Announce file system status of command
    This will output information like owner, group, atime, mtime, ctime, size,
    mode and if command is executable.

    Given a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-command-filesystem-status
      Scenario: Run command
        And I run `aruba-test-cli`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    # mode       => 755
    """
    And the output should contain:
    """
    # owner
    """
    And the output should contain:
    """
    # group
    """
    And the output should contain:
    """
    # ctime
    """
    And the output should contain:
    """
    # mtime
    """
    And the output should contain:
    """
    # atime
    """
    And the output should contain:
    """
    # size
    """
    And the output should contain:
    """
    # executable
    """

  Scenario: Announce content of command
    This will output the content of the executable command. Be careful doing
    this with binary executables. This hook should be used with scripts only.

    Given a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce command content
      @announce-command-content
      Scenario: Run command
        And I run `aruba-test-cli`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    #!/usr/bin/env ruby
    # frozen_string_literal: true
    
    $LOAD_PATH << File.expand_path('../lib', __dir__)
    """

  Scenario: Announce everything
    Given a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce
      Scenario: Run command
        When I run `aruba-test-cli`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain "<<-STDOUT"
    And the output should contain "<<-STDERR"
    And the output should contain "<<-COMMAND"
    And the output should contain "<<-COMMAND FILESYSTEM STATUS"
