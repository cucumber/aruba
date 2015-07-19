Feature: All output of commands which were executed

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the output should contain" step

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Detect subset of one-line output
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts 'hello world'
    """
    And a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should contain "hello world"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect absence of one-line output
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts 'hello world'
    """
    And a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should not contain "good-bye"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect subset of multiline output
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts "hello\nworld"
    """
    And a file named "features/output.feature" with:
    """
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

    @debug
  Scenario: Detect absence of subset of multiline output
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts "hello\nworld"
    """
    And a file named "features/output.feature" with:
    """
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

    @posix
  Scenario: Detect exact one-line output for posix commands
    Given a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `printf 'hello world'`
        Then the output should contain exactly:
        \"\"\"
        hello world
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect exact one-line output for ruby commands
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    print "hello world"
    """
    And a file named "features/output.feature" with:
    """
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

    When I run `printf "\e[36mhello world\e[0m"`
    Then the output should contain exactly:
      """
      """

  @ansi
  Scenario: Detect exact one-line output with ANSI output
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    print "\e[36mhello world\e[0m"
    """
    And a file named "features/output.feature" with:
    """
    Feature: Run command
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
    Given the default aruba timeout is 12 seconds
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    print "\e[36mhello world\e[0m"
    """
    And a file named "features/output.feature" with:
    """
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
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    print "hello\nworld"
    """
    And a file named "features/output.feature" with:
    """
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
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts 'hello world'
    """
    And a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should contain "hello world"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect subset of one-line output with regex
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts 'hello, ruby'
    """
    And a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should match /^hello(, world)?/
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect subset of multiline output with regex
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts "hello\nworld\nextra line1\nextra line2\nimportant line"
    """
    And a file named "features/output.feature" with:
    """
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
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts "hello, ruby"
    """
    And a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the output should not match /ruby is a better perl$/
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Negative matching of multiline output with regex
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts "hello\nworld\nextra line1\nextra line2\nimportant line"
    """
    And a file named "features/output.feature" with:
    """
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
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts "hello world"
    exit 0
    """
    And a file named "features/output.feature" with:
    """
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
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    print "hello\nworld"
    exit 0
    """
    And a file named "features/output.feature" with:
    """
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
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts "hello\nworld"
    exit 1
    """
    And a file named "features/output.feature" with:
    """
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
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    puts "hello\nworld"
    exit 1
    """
    And a file named "features/output.feature" with:
    """
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
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    puts "hello\nworld"
    exit 1
    """
    And a file named "features/output.feature" with:
    """
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

  Scenario: Detect output from all processes
    Given an executable named "bin/cli1" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    puts 'This is cli1'
    """
    And an executable named "bin/cli2" with:
    """
    #!/usr/bin/env ruby

    $LOAD_PATH << File.expand_path('../../lib', __FILE__)
    require 'cli/app'

    puts 'This is cli2'
    """
    And a file named "features/output.feature" with:
    """
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
