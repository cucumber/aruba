Feature: Debug your command in cucumber-test-run
  As a developer
  In order to find a bug
  I want to use some debugger in my code

  Background:
    Given I use a fixture named "cli-app"
    And the default aruba exit timeout is 60 seconds

  @unsupported-on-platform-java
  Scenario: You can use a debug repl in your cli program

    If you want to debug an error, which only occurs in one of your
    `cucumber`-tests, the `@debug`-tag becomes handy. This will use the
    DebugProcess runner, making your program use the default stdin, stdout and
    stderr streams so you can interact with it directly.

    This will, for example, make `binding.pry` and `byebug` work in your
    program. However, Aruba steps that access the input and output of your
    program will not work.

    Please make sure, that there's a statement after the `binding.pry`-call.
    Otherwise you might not get an interactive shell, because your program will
    just exit.

    We are going to demonstrate this using `pry`, but any other interactive
    debugger for any other programming language should also work.

    Given an executable named "bin/aruba-test-cli" with:
    """ruby
    #!/usr/bin/env ruby

    $stderr.sync = true
    $stdout.sync = true

    foo = 'hello'

    require 'pry'
    binding.pry

    exit 0
    """
    And a file named "features/debug.feature" with:
    """cucumber
    Feature: Exit status in debug environment

      @debug
      Scenario: Run program with debug code
        When I run `aruba-test-cli`
        Then the exit status should be 0
    """
    When I run `cucumber` interactively
    And I type "foo"
    And I type "exit"
    Then the output should contain:
    """
    [1] pry(main)> foo
    => "hello"
    [2] pry(main)> exit
    """

  Scenario: Can handle announcers
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    exit 0
    """
    And a file named "features/debug.feature" with:
    """cucumber
    Feature: Exit status in debug environment

      @debug
      @announce
      Scenario: Run program with debug code
        When I run `aruba-test-cli`
        Then the exit status should be 0
    """
    When I successfully run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    <<-STDOUT
    This is the debug launcher on STDOUT. If this output is unexpected, please check your setup.
    STDOUT
    """
