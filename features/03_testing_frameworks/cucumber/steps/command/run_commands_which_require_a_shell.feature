Feature: Running shell commands

  You can run an *ad hoc* script with the following steps:
  - `When I run the following script:`

  Or you can run shell commands with:
  - `I run the following commands`
  - `I run the following commands (in|with) \`interpreter\``
  - `I run the following commands (in|with) \`/path/to/interpreter\``

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Creating and running scripts
    Given a file named "features/shell.feature" with:
    """
    Feature: Running scripts
      Scenario: Running ruby script
        When I run the following script:
        \"\"\"bash
        #!/usr/bin/env ruby

        puts "Hello"
        \"\"\"
        Then the output should contain "Hello"

      Scenario: Running python script
        When I run the following script:
        \"\"\"bash
        #!/usr/bin/env python

        print("Hello")
        \"\"\"
        Then the output should contain exactly "Hello"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Running shell commands
    Given a file named "features/shell.feature" with:
    """
    Feature: Running scripts
      Scenario: Running shell commands
        When I run the following commands:
        \"\"\"bash
        echo "Hello shell"
        \"\"\"
        Then the output should contain exactly "Hello shell"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Running commands with a named interpreter
    Given a file named "features/shell.feature" with:
    """
    Feature: Running scripts
      Scenario: Running ruby commands
        When I run the following commands with `ruby`:
        \"\"\"
        puts "Hello, Aruba!"
        \"\"\"
        Then the output should contain "Hello, Aruba!"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Running commands if full path to interpreter is given
    Given a file named "features/shell.feature" with:
    """
    Feature: Running full path
      Scenario: Running full path bash
        When I run the following commands with `/bin/bash`:
        \"\"\"bash
        echo "Hello Aruba!"
        \"\"\"
        Then the output should contain "Hello Aruba!"
    """
    When I run `cucumber`
    Then the features should all pass
