@unsupported-on-platform-unix @unsupported-on-platform-mac
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
    And the output should contain:
    """
    $ cd C:/
    """
    And the output should contain:
    """
    tmp/aruba/dir.d
    """

  Scenario: Announce stdout
    Given an executable named "bin/aruba-test-cli.bat" with:
    """bash
    @echo off
    echo Hello World
    """
    And a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-stdout
      Scenario: Run command
        When I run `aruba-test-cli.bat`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should match %r<<<-STDOUT\s*Hello World\s*STDOUT>

  Scenario: Announce stderr
    Given an executable named "bin/aruba-test-cli.bat" with:
    """bash
    @echo off
    echo Hello World >&2
    """
    And a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-stderr
      Scenario: Run command
        When I run `aruba-test-cli.bat`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should match %r<<<-STDERR\s*Hello World\s*STDERR>

  Scenario: Announce both stderr and stdout
    Given an executable named "bin/aruba-test-cli.bat" with:
    """bash
    @echo off
    echo Hello >&2
    echo World
    """
    And a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-output
      Scenario: Run command
        When I run `aruba-test-cli.bat`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should match %r<<<-STDERR\s*Hello\s*STDERR>
    And the output should match %r<<<-STDOUT\s*World\s*STDOUT>

  Scenario: Announce command
    Given an executable named "bin/aruba-test-cli.bat" with:
    """bash
    @echo off
    echo Hello World
    """
    And a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-command
      Scenario: Run command
        When I run `aruba-test-cli.bat`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    $ aruba-test-cli
    """

  Scenario: Announce change of environment variable
    Given an executable named "bin/aruba-test-cli.bat" with:
    """bash
    @echo off
    echo Hello World
    """
    And a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-changed-environment
      Scenario: Run command
        When I set the environment variables to:
          | variable | value    |
          | MY_VAR   | my_value |
        And I run `aruba-test-cli.bat`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    $ export MY_VAR=my_value
    """

  Scenario: Announce change of environment variable which contains special characters
    Given an executable named "bin/aruba-test-cli.bat" with:
    """bash
    @echo off
    echo Hello World
    """
    And a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-changed-environment
      Scenario: Run command
        When I set the environment variables to:
          | variable | value      |
          | MY_VAR   | my value ! |
        And I run `aruba-test-cli.bat`
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

    Given an executable named "bin/aruba-test-cli.bat" with:
    """bash
    @echo off
    echo Hello World
    """
    And a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-command-filesystem-status
      Scenario: Run command
        And I run `aruba-test-cli.bat`
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

    Given an executable named "bin/aruba-test-cli.bat" with:
    """bash
    @echo off
    echo Hello World
    """
    And a file named "features/exit_status.feature" with:
    """cucumber
    Feature: Announce
      @announce-command-content
      Scenario: Run command
        And I run `aruba-test-cli.bat`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should match %r<@echo off\s*echo Hello World>