Feature: Run commands with Aruba

  As long as you've got the neccessary programs, libraries, runtime
  environments, interpreters installed, it doesn't matter in which programming
  language your commandline application is implemented. You can even use POSIX
  standard tools like "printf".

  Below you find some examples of the "Hello, Aruba!"-application implemented
  with different programming languages and a single example for a POSIX
  standard tool. This is NOT an exclusive list. Every commandline application
  should run with `aruba`.

  Background:
    Given I use a fixture named "getting-started-app"
    And a file named "features/hello_aruba.feature" with:
    """
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given I successfully run `cli`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """

  Scenario: Bash Program
    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    echo "Hello, Aruba!"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Ruby Program
    Given an executable named "bin/cli" with:
    """ruby
    #!/usr/bin/env ruby

    puts "Hello, Aruba!"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Bash Program run via bash
    Given a file named "tmp/aruba/bin/cli.sh" with:
    """bash
    echo "Hello, Aruba!"
    """
    And a file named "features/hello_aruba.feature" with:
    """
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given I successfully run `bash bin/cli.sh`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Ruby Program
    Given an executable named "bin/cli" with:
    """ruby
    #!/usr/bin/env ruby

    puts "Hello, Aruba!"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Ruby Program via "ruby"
    Given an executable named "bin/cli.rb" with:
    """ruby
    puts "Hello, Aruba!"
    """
    And a file named "features/hello_aruba.feature" with:
    """
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given I successfully run `ruby bin/cli.rb`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Python Program
    Given an executable named "bin/cli" with:
    """python
    #!/usr/bin/env python

    print("Hello, Aruba!")
    """
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Python Program via "python"
    Given a file named "bin/cli.py" with:
    """python
    print("Hello, Aruba!")
    """
    And a file named "features/hello_aruba.feature" with:
    """
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given I successfully run `python bin/cli.py`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Perl Program
    Given an executable named "bin/cli" with:
    """perl
    #!/usr/bin/env perl

    print "Hello, Aruba!\n";
    """
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Perl Program via "perl"
    Given an executable named "bin/cli.pl" with:
    """perl
    print "Hello, Aruba!\n";
    """
    And a file named "features/hello_aruba.feature" with:
    """
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given I successfully run `perl bin/cli.pl`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: Java Program

    It's even possible to compile and run Java programs with Aruba.

    Given a file named "features/hello_aruba.feature" with:
    """cucumber
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given a file named "tmp/HelloArubaApp.java" with:
        \"\"\"
        class HelloArubaApp {
          public static void main(String[] args) {
            System.out.println("Hello, Aruba!");
          }
        }
        \"\"\"
        And I successfully run `javac tmp/HelloArubaApp.java`
        And I cd to "tmp/"
        And I successfully run `java HelloArubaApp`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  Scenario: POSIX standard tools
    Given a file named "features/hello_aruba.feature" with:
    """
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given I successfully run `printf "%s" "Hello, Aruba!"`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber`
    Then the features should all pass
