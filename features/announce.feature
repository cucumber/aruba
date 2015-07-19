Feature: Announce output during test run

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the output should contain" step

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Announce change of directory (deprecated)
    Given a file named "features/exit_status.feature" with:
    """
    Feature: Announce
      @announce-dir
      Scenario: Run command
        Given a directory named "dir.d"
        When I cd to "dir.d"
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    $ cd /
    """
    And the output should contain:
    """
    tmp/aruba/dir.d
    """

  Scenario: Announce change of directory
    Given a file named "features/exit_status.feature" with:
    """
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
    $ cd /
    """
    And the output should contain:
    """
    tmp/aruba/dir.d
    """

  Scenario: Announce stdout
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    puts 'Hello World'
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Announce
      @announce-stdout
      Scenario: Run command
        When I run `cli`
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

  Scenario: Announce stderr
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    $stderr.puts 'Hello World'
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Announce
      @announce-stderr
      Scenario: Run command
        When I run `cli`
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

  Scenario: Announce both stderr and stdout
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    $stderr.puts 'Hello'
    puts 'World'
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Announce
      @announce-output
      Scenario: Run command
        When I run `cli`
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
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    $stderr.puts 'Hello'
    puts 'World'
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Announce
      @announce-cmd
      Scenario: Run command
        When I run `cli`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    $ cli
    """

  Scenario: Announce change of environment variable
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts 'World'
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Announce
      @announce-env
      Scenario: Run command
        When I set the environment variables to:
          | variable | value    |
          | MY_VAR   | my_value |
        And I run `cli`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    $ export MY_VAR=my_value
    """

  Scenario: Announce change of environment variable which contains special characters
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts 'World'
    """
    And a file named "features/exit_status.feature" with:
    """
    Feature: Announce
      @announce-env
      Scenario: Run command
        When I set the environment variables to:
          | variable | value      |
          | MY_VAR   | my value ! |
        And I run `cli`
        Then the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    $ export MY_VAR=my\ value\ \
    """
