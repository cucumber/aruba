Feature: Debug your command in cucumber-test-run

  As a developer
  I want to use some debugger in my code and therefor need system() to execute my program
  In order to find a bug

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Can handle exit status 0
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    exit 0
    """
    And a file named "features/debug.feature" with:
    """
    Feature: Exit status in debug environment

      @debug
      Scenario: Run program with debug code
        When I run `cli`
        Then the exit status should be 0
    """
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Can handle exit status 1
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    exit 1
    """
    And a file named "features/debug.feature" with:
    """
    Feature: Exit status in debug environment

      @debug
      Scenario: Run program with debug code
        When I run `cli`
        Then the exit status should be 1
    """
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: You can use a debug repl in your cli program

    If you want to debug a strange error, which only occures in one of your
    `cucumber`-tests, the `@debug`-tag becomes handy. You can add `@debug` in
    front of your feature/scenario to make `binding.pry` or `byebug` work in
    your program.

    Please make sure, that there's a statement after the `binding.pry`-call.
    Otherwise you might not get an interactive shell, because your program will
    just exit.

    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    $stderr.sync = true
    $stdout.sync = true

    require 'pry'
    binding.pry

    exit 0
    """
    And a file named "features/debug.feature" with:
    """
    Feature: Exit status in debug environment

      @debug
      Scenario: Run program with debug code
        When I run `cli`
        Then the exit status should be 0
    """
    When I run `cucumber` interactively
    And I stop the command started last if output contains:
    """
    pry
    """
    Then the output should contain:
    """
    pry(main)>
    """
