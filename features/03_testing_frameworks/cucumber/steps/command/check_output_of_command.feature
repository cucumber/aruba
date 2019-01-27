Feature: All output of commands which were executed

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the output should contain" step

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Detect subset of one-line output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'hello world'
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should contain "hello world"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect absence of one-line output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'hello world'
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should not contain "good-bye"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect subset of multiline output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo -e "hello\nworld"
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should contain:
        \"\"\"
        hello
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect absence of subset of multiline output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo -e "hello\nworld"
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should not contain:
        \"\"\"
        good-bye
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect exact one-line output
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `echo 'hello world'`
        Then the output should contain exactly:
        \"\"\"
        hello world
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect exact one-line output with ANSI output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo -e "\e[36mhello world\e[0m"
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      @keep-ansi-escape-sequences
      Scenario: Run command
        When I run `cli`
        Then the output should contain exactly:
        \"\"\"
        \e[36mhello world\e[0m
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect exact one-line output with ANSI output stripped by default
    Given the default aruba exit timeout is 12 seconds
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo -e "\e[36mhello world\e[0m"
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should contain exactly:
        \"\"\"
        hello world
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect exact multiline output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo -ne "hello\nworld"
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should contain exactly:
        \"\"\"
        hello
        world
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect subset of one-line output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'hello world'
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should contain "hello world"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect subset of one-line output with regex
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'hello, ruby'
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should match /^hello(, world)?/
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect subset of multiline output with regex
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo -e "hello\nworld\nextra line1\nextra line2\nimportant line"
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should match:
        \"\"\"
        he..o
        wor.d
        .*
        important line
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Negative matching of one-line output with regex
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo "hello, ruby"
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should not match /ruby is a better perl$/
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Negative matching of multiline output with regex
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo -e "hello\nworld\nextra line1\nextra line2\nimportant line"
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should not match:
        \"\"\"
        ruby
        is
        a
        .*
        perl
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Match passing exit status and partial output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo "hello world"
    exit 0
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then it should pass with:
        \"\"\"
        hello
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Match passing exit status and exact output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo -ne "hello\nworld"
    exit 0
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then it should pass with exactly:
        \"\"\"
        hello
        world
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Match failing exit status and partial output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo -e "hello\nworld"
    exit 1
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then it should fail with:
        \"\"\"
        hello
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass


  Scenario: Match failing exit status and exact output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo -e "hello\nworld"
    exit 1
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then it should fail with:
        \"\"\"
        hello
        world
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Match failing exit status and output with regex
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo -e "hello\nworld"
    exit 1
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then it should fail with regex:
        \"\"\"
        hello\s*world
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  @requires-aruba-version-1
  Scenario: Detect output from all processes
    Given an executable named "bin/cli1" with:
    """bash
    #!/usr/bin/env bash

    echo 'This is cli1'
    """
    And an executable named "bin/cli2" with:
    """bash
    #!/usr/bin/env bash

    echo 'This is cli2'
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli1`
        When I run `cli2`
        Then the stdout should contain exactly:
        \"\"\"
        This is cli1
        \"\"\"
        And the stdout should contain exactly:
        \"\"\"
        This is cli2
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect output from all processes (deprecated)
    Given an executable named "bin/cli1" with:
    """bash
    #!/usr/bin/env bash

    echo 'This is cli1'
    """
    And an executable named "bin/cli2" with:
    """bash
    #!/usr/bin/env bash

    echo 'This is cli2'
    """
    And a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `cli1`
        When I run `cli2`
        Then the stdout should contain exactly:
        \"\"\"
        This is cli1
        This is cli2
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Handle little output
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    for ((c=0; c<256; c = c+1)); do 
      echo -n "a"
    done
    """
    And a file named "features/flushing.feature" with:
    """cucumber
    Feature: Flushing output
      Scenario: Run command
        When I run `cli`
        Then the output should contain "a"
        And the output should be 256 bytes long
        And the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Handle tons of output

    In order to test processes that output a lot of data
    As a developer using Aruba
    I want to make sure that large amounts of output aren't buffered

    Given the default aruba exit timeout is 10 seconds
    And an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    for ((c=0; c<65536; c = c+1)); do
      echo -n "a"
    done
    """
    And a file named "features/flushing.feature" with:
    """cucumber
    Feature: Flushing output
      Scenario: Run command
        When I run `cli`
        Then the output should contain "a"
        And the output should be 65536 bytes long
        And the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Handle tons of interactive output
    Given the default aruba exit timeout is 10 seconds
    And an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    read size; for ((c=0; c<$size; c = c+1)); do
      echo -n "a"
    done
    """
    And a file named "features/flushing.feature" with:
    """cucumber
    Feature: Flushing output
      Scenario: Run command
        When I run `cli` interactively
        And I type "65536"
        Then the output should contain "a"
        And the output should be 65536 bytes long
        And the exit status should be 0
    """
    When I run `cucumber`
    Then the features should all pass

  @requires-aruba-version-1
  Scenario: Detect output from all processes normal and interactive ones
    Given an executable named "bin/cli1" with:
    """
    #!/usr/bin/env bash
    echo 'This is cli1'
    """
    And an executable named "bin/cli2" with:
    """
    #!/usr/bin/env ruby

    while input = gets do
      break if "" == input
      puts input
    end
    """
    And a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `cli1`
        When I run `cli2` interactively
        And I type "This is cli2"
        And I type ""
        Then the stdout should contain exactly:
        \"\"\"
        This is cli1
        \"\"\"
        And the stdout should contain exactly:
        \"\"\"
        This is cli2
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect output from named source
    Given a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `printf 'simple'`
        And I run `cat` interactively
        And I type "interactive"
        And I type ""
        Then the output from "printf 'simple'" should contain "simple"
        And the output from "printf 'simple'" should contain exactly "simple"
        And the output from "printf 'simple'" should contain exactly:
        \"\"\"
        simple
        \"\"\"
        And the output from "cat" should not contain "simple"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect second output from named source with custom name
    Given a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I set the environment variable "ARUBA_TEST_VAR" to "first"
        And I run `bash -c 'printf $ARUBA_TEST_VAR'`
        Then the output from "bash -c 'printf $ARUBA_TEST_VAR'" should contain "first"
        When I set the environment variable "ARUBA_TEST_VAR" to "second"
        And I run `bash -c 'printf $ARUBA_TEST_VAR'`
        Then the output from "bash -c 'printf $ARUBA_TEST_VAR'" should contain "second"
    """
    When I run `cucumber`
    Then the features should all pass
