Feature: Supported programming languages

  As long as you've got the neccessary programs, libraries, runtime
  environments, interpreters installed, it doesn't matter in which programming
  language your commandline application is implemented. 

  Below you find some examples of the "Hello, Aruba!"-application implemented
  with different programming languages. This is NOT an exclusive list. Every
  commandline application should run with `aruba`.

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

  Scenario: Python Program
    Given an executable named "bin/cli" with:
    """python
    #!/usr/bin/env python

    print("Hello, Aruba!")
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
