Feature: Stdout of commands which were executed

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "the output should contain" step

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Match output in stdout
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
        Then the stdout should contain "hello"
        Then the stderr should not contain "hello"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Match stdout on several lines
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts 'GET /'
    """
    And a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the stdout should contain:
        \"\"\"
        GET /
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Match output on several lines where stdout contains quotes
    Given a file named "bin/cli" with:
    """
    #!/usr/bin/env ruby

    puts 'GET "/"'
    """
    And a file named "features/output.feature" with:
    """
    Feature: Run command
      Scenario: Run command
        When I run `cli`
        Then the stdout should contain:
        \"\"\"
        GET "/"
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass
