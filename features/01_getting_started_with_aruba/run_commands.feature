Feature: Run commands with Aruba

  As long as you've got the neccessary programs, libraries, runtime
  environments, interpreters installed, it doesn't matter in which programming
  language your command line application is implemented. You can also run any
  program that is in your $PATH.

  Background:
    Given I use a fixture named "getting-started-app"

  @requires-bash
  Scenario: Bash Program
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo "Hello, Aruba!"
    """
    And a file named "features/hello_aruba.feature" with:
    """
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given I successfully run `aruba-test-cli`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  @requires-bash
  Scenario: Bash Program run via bash
    Given a file named "features/hello_aruba.feature" with:
    """
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given a file named "cli.sh" with:
        \"\"\"
        echo "Hello, Aruba!"
        \"\"\"
        When I successfully run `bash ./cli.sh`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  @requires-ruby
  Scenario: Ruby Program
    Given an executable named "bin/aruba-test-cli" with:
    """ruby
    #!/usr/bin/env ruby

    puts "Hello, Aruba!"
    """
    And a file named "features/hello_aruba.feature" with:
    """
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given I successfully run `aruba-test-cli`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  @requires-ruby
  Scenario: Ruby Program via "ruby"
    Given a file named "features/hello_aruba.feature" with:
    """
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given a file named "cli.rb" with:
        \"\"\"
        puts "Hello, Aruba!"
        \"\"\"
        When I successfully run `ruby ./cli.rb`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber`
    Then the features should all pass
