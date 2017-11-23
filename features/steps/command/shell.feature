Feature: Running shell commands

  You can run an *ad hoc* script with the following steps:
  - `When I run the following script:`

  Or you can run shell commands with:
  - `I run the following (bash|zsh|...shell)? commands`
  - `I run the following (bash|zsh|...shell)? commands (in|with) \`interpreter\``
  - `I run the following (bash|zsh|...shell)? commands (in|with) \`/path/to/interpreter\``

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

  Scenario: Running bash commands
    Given a file named "features/shell.feature" with:
    """
    Feature: Running scripts
      Scenario: Running bash commands
        When I run the following commands with `bash`:
        \"\"\"bash
        echo -n "Hello "
        echo `echo bash` # subshell
        \"\"\"
        Then the output should contain exactly "Hello bash"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Running zsh commands
    Given a file named "features/shell.feature" with:
    """
    Feature: Running zsh scripts
      Scenario: Running zsh commands
        When I run the following commands with `zsh`:
        \"\"\"bash
        echo "Hello \c"
        echo $((2 + 2))
        \"\"\"
        Then the output should contain exactly "Hello 4"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Running ruby commands
    Given a file named "features/shell.feature" with:
    """
    Feature: Running scripts
      Scenario: Running ruby commands
        When I run the following commands with `ruby`:
        \"\"\"ruby
        puts "Hello, Aruba!"
        \"\"\"
        Then the output should contain "Hello, Aruba!"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Running python commands
    Given a file named "features/shell.feature" with:
    """
    Feature: Running scripts
      Scenario: Running ruby commands
        When I run the following commands with `python`:
        \"\"\"ruby
        print("Hello, Aruba!")
        \"\"\"
        Then the output should contain exactly "Hello, Aruba!"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Running commands if full path to interpreter is given
    Given a file named "features/shell.feature" with:
    """
    Feature: Running full path zsh
      Scenario: Running zsh commands #1
        When I run the following commands with `/bin/zsh`:
        \"\"\"bash
        echo "Hello \c"
        echo $((6 - 2))
        \"\"\"
        Then the output should contain exactly "Hello 4"

      Scenario: Running zsh commands #1
        When I run the following commands in `/bin/zsh`:
        \"\"\"bash
        echo "Hello \c"
        echo $((6 - 2))
        \"\"\"
        Then the output should contain exactly "Hello 4"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Running commands if only the name of interpreter is given
    Given a file named "features/shell.feature" with:
    """
    Feature: Running full path zsh
      Scenario: Running zsh commands #1
        When I run the following commands with `zsh`:
        \"\"\"bash
        echo "Hello \c"
        echo $((6 - 2))
        \"\"\"
        Then the output should contain exactly "Hello 4"

      Scenario: Running zsh commands #2
        When I run the following commands in `zsh`:
        \"\"\"bash
        echo "Hello \c"
        echo $((6 - 2))
        \"\"\"
        Then the output should contain exactly "Hello 4"
    """
    When I run `cucumber`
    Then the features should all pass
