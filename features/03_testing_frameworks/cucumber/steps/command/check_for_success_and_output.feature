Feature: Checking success and output together

  In order to specify expected output and success
  As a developer using Cucumber
  I want to use the "it should pass with" step family

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Match passing exit status and partial output
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `echo hello world`
        Then it should pass with:
        \"\"\"
        hello
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Match passing exit status and exact output
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `ruby -e 'puts "hello\nworld"; exit 0'`
        Then it should pass with exactly:
        \"\"\"
        hello
        world
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Match failing exit status and partial output
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `ruby -e 'puts "hello\nworld"; exit 1'`
        Then it should fail with:
        \"\"\"
        hello
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Match failing exit status and exact output
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `ruby -e 'puts "hello\nworld"; exit 1'`
        Then it should fail with exactly:
        \"\"\"
        hello
        world
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Match failing exit status and output with regex
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `ruby -e 'puts "hello\nworld"; exit 1'`
        Then it should fail with regex:
        \"\"\"
        hello\s*world
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Detect output from all processes
    Given a file named "features/output.feature" with:
    """cucumber
    Feature: Run command
      Scenario: Run command
        When I run `echo hello`
        And I run `echo good-bye`
        Then the stdout should contain exactly:
        \"\"\"
        hello
        good-bye
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass
