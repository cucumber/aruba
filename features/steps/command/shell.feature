Feature: Running shell commands

  You can run an *ad hoc* script with the following step
  - `When I run the following script:`

  Or you can run shell commands with:
  - `I run the following (bash|zsh|fish|dash)? commands`

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Running ruby script
    Given a file named "features/shell.feature" with:
    """
    Feature: Running scripts
      Scenario: Running ruby script
        When I run the following script:
        \"\"\"bash
        #!/usr/bin/env ruby

        puts "Hello"
        \"\"\"
        Then the output should contain exactly "Hello"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Running python script
    Given a file named "features/shell.feature" with:
    """
    Feature: Running scripts
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
        echo "Hello \c"
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
        When I run the following commands in `zsh`:
        \"\"\"bash
        echo "Hello \c"
        echo $((2 + 2))
        \"\"\"
        Then the output should contain exactly "Hello 4"

      Scenario: Running zsh commands
        When I run the following commands with `/bin/zsh`:
        \"\"\"bash
        echo "Hello \c"
        echo $((6 - 2))
        \"\"\"
        Then the output should contain exactly "Hello 4"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Running fish commands
    Given a file named "features/shell.feature" with:
    """
    Feature: Running fish scripts
      Scenario: Running fish commands
        When I run the following commands with `fish`:
        \"\"\"bash
        echo -n "Hello "
        echo (echo fish)
        \"\"\"
        Then the output should contain exactly "Hello fish"

      Scenario: Running fish commands with explicit path
        When I run the following commands with `/usr/bin/env fish`:
        \"\"\"bash
        echo -n "Hello "
        echo (echo fish)
        \"\"\"
        Then the output should contain exactly "Hello fish"
    """
    When I run `cucumber`
    Then the features should all pass
