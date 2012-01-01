Feature: file system commands

  In order to specify commands that load files
  As a developer using Cucumber
  I want to create temporary files
  
  Scenario: create a dir
    Given a directory named "foo/bar"
    When I run `ruby -e "puts test ?d, 'foo'"`
    Then the stdout should contain "true"
  
  Scenario: create a file
    Given a file named "foo/bar/example.rb" with:
      """
      puts "hello world"
      """
    When I run `ruby foo/bar/example.rb`
    Then the output should contain "hello world"

  Scenario: create a fixed sized file
    Given a 1048576 byte file named "test.txt"
    Then a 1048576 byte file named "test.txt" should exist

  Scenario: Append to a file
    \### We like appending to files:
    1. Disk space is cheap
    1. It's completely safe

    \### Here is a list:
    - One
    - Two

    Given a file named "foo/bar/example.feature" with:
      """
      Feature: Example
        Hello World
      """
    And a file named "foo/bar/example.rb" with:
      """
      puts "\e[31mhello world\e[0m"

      """
    When I append to "foo/bar/example.rb" with:
      """
      puts "this was appended"

      """
    When I run `ruby foo/bar/example.rb`
    Then the stdout should contain "hello world"
    And the stdout should contain "this was appended"

  Scenario: Append to a new file
    When I append to "thedir/thefile" with "x"
    And I append to "thedir/thefile" with "y"
    Then the file "thedir/thefile" should contain "xy"

  Scenario: clean up files generated in previous scenario
    When I run `ruby foo/bar/example.rb`
    Then the exit status should be 1
    And the output should contain "No such file or directory -- foo/bar/example.rb"
  
  Scenario: change to a subdir
    Given a file named "foo/bar/example.rb" with:
      """
      puts "hello world"
      """
    When I cd to "foo/bar"
    And I run `ruby example.rb`
    Then the output should contain "hello world"

  Scenario: Reset current directory from previous scenario
    When I run `ruby example.rb`
    Then the exit status should be 1

  Scenario: Holler if cd to bad dir
    Given a file named "foo/bar/example.rb" with:
      """
      puts "hello world"
      """
    When I do aruba I cd to "foo/nonexistant"
    Then aruba should fail with "tmp/aruba/foo/nonexistant is not a directory"

  Scenario: Check for presence of a subset of files
    Given an empty file named "lorem/ipsum/dolor"
    Given an empty file named "lorem/ipsum/sit"
    Given an empty file named "lorem/ipsum/amet"
    Then the following files should exist:
      | lorem/ipsum/dolor |
      | lorem/ipsum/amet  |

  Scenario: Check for absence of files
    Then the following files should not exist:
      | lorem/ipsum/dolor |

  Scenario: Check for presence of a single file
    Given an empty file named "lorem/ipsum/dolor"
    Then a file named "lorem/ipsum/dolor" should exist

  Scenario: Check for absence of a single file
    Then a file named "lorem/ipsum/dolor" should not exist

  Scenario: Check for presence of a subset of directories
    Given a directory named "foo/bar"
    Given a directory named "foo/bla"
    Then the following directories should exist:
      | foo/bar |
      | foo/bla |

  Scenario: check for absence of directories
    Given a directory named "foo/bar"
    Given a directory named "foo/bla"
    Then the following step should fail with Spec::Expectations::ExpectationNotMetError:
    """
    Then the following directories should not exist:
      | foo/bar/ |
      | foo/bla/ |
    """

  Scenario: Check for presence of a single directory
    Given a directory named "foo/bar"
    Then a directory named "foo/bar" should exist

  Scenario: Check for absence of a single directory
    Given a directory named "foo/bar"
    Then the following step should fail with Spec::Expectations::ExpectationNotMetError:
      """
      Then a directory named "foo/bar" should not exist
      """

  Scenario: Check file contents
    Given a file named "foo" with:
      """
      hello world
      """
    Then the file "foo" should contain "hello world"
    And the file "foo" should not contain "HELLO WORLD"

  Scenario: Check file contents with regexp
    Given a file named "foo" with:
      """
      hello world
      """
    Then the file "foo" should match /hel.o world/
    And the file "foo" should not match /HELLO WORLD/

  Scenario: Check file contents with docstring
    Given a file named "foo" with:
      """
      foo
      bar
      baz
      foobar
      """
    Then the file "foo" should contain:
      """
      bar
      baz
      """

  Scenario: Remove file
    Given a file named "foo" with:
      """
      hello world
      """
    When I remove the file "foo"
    Then the file "foo" should not exist

  Scenario: Just a dummy for reporting
    Given an empty file named "a/b.txt"
    Given an empty file named "a/b/c.txt"
    Given an empty file named "a/b/c/d.txt"
