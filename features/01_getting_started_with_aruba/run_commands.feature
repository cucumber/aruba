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

  @requires-python
  Scenario: Python Program
    Given an executable named "bin/aruba-test-cli" with:
    """python
    #!/usr/bin/env python

    print("Hello, Aruba!")
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

  @requires-python
  Scenario: Python Program via "python"
    Given a file named "features/hello_aruba.feature" with:
    """
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given a file named "cli.py" with:
        \"\"\"
        print("Hello, Aruba!")
        \"\"\"
        When I successfully run `python ./cli.py`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  @requires-perl
  Scenario: Perl Program
    Given an executable named "bin/aruba-test-cli" with:
    """perl
    #!/usr/bin/env perl

    print "Hello, Aruba!\n";
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

  @requires-perl
  Scenario: Perl Program via "perl"
    Given a file named "features/hello_aruba.feature" with:
    """
    Feature: Getting Started With Aruba
      Scenario: First Run of Command
        Given a file named "cli.pl" with:
        \"\"\"perl
        print "Hello, Aruba!\n";
        \"\"\"
        When I successfully run `perl ./cli.pl`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber`
    Then the features should all pass

  @requires-java
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
        And I successfully run `javac tmp/HelloArubaApp.java` for up to 20 seconds
        And I cd to "tmp/"
        And I successfully run `java HelloArubaApp`
        Then the output should contain:
        \"\"\"
        Hello, Aruba!
        \"\"\"
    """
    When I successfully run `cucumber` for up to 21 seconds
    Then the features should all pass

  @requires-posix-standard-tools
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
