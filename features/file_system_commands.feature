Feature: file system commands

  In order to specify commands that load files
  As a developer using Cucumber
  I want to create temporary files

  Scenario: create a dir
    Given a directory named "foo/bar"
    When I run `file foo/bar`
    Then the stdout should contain "foo/bar: directory"

  Scenario: create a file
    Given a file named "foo/bar/example.txt" with:
      """
      hello world
      """
    When I run `cat foo/bar/example.txt`
    Then the output should contain exactly "hello world"

  Scenario: a file does not exist
    Given a file named "example.txt" does not exist
    Then the file "example.txt" should not exist

  Scenario: a directory does not exist
    Given a directory named "example.d" does not exist
    Then the directory "foo" should not exist

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

    Given a file named "foo/bar/example.txt" with:
      """
      hello world

      """
    When I append to "foo/bar/example.txt" with:
      """
      this was appended

      """
    When I run `cat foo/bar/example.txt`
    Then the stdout should contain "hello world"
    And the stdout should contain "this was appended"

  Scenario: Append to a new file
    When I append to "thedir/thefile" with "x"
    And I append to "thedir/thefile" with "y"
    Then the file "thedir/thefile" should contain "xy"

  Scenario: clean up files generated in previous scenario
    Then the file "foo/bar/example.txt" should not exist

  Scenario: change to a subdir
    Given a file named "foo/bar/example.txt" with:
      """
      hello world

      """
    When I cd to "foo/bar"
    And I run `cat example.txt`
    Then the output should contain "hello world"

  Scenario: Reset current directory from previous scenario
    When I run `pwd`
    Then the output should match /\057tmp\057aruba$/

  Scenario: Holler if cd to bad dir
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

  Scenario: Check for absence of a single file using a regex
    Then a file matching %r<^ipsum> should not exist

  Scenario: Check for presence of a single file using a regex
    Given an empty file named "lorem/ipsum/dolor"
    Then a file matching %r<dolor$> should exist

  Scenario: Check for presence of a single file using a more complicated regex
    Given an empty file named "lorem/ipsum/dolor"
    Then a file matching %r<ipsum/dolor> should exist

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
      Then the directory "foo/bar" should not exist
      """

  Scenario: Check file contents with text
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

  Scenario: Check file contents with another file
    Given a file named "foo" with:
      """
      hello world
      """
    And a file named "bar" with:
      """
      hello world
      """
    And a file named "nonbar" with:
      """
      hello another world
      """
    Then the file "foo" should be equal to file "bar"
    And the file "foo" should not be equal to file "nonbar"

  Scenario: Remove file
    Given a file named "foo" with:
      """
      hello world
      """
    When I remove the file "foo"
    Then the file "foo" should not exist

  Scenario: Remove directory
    Given a directory named "foo"
    When I remove the directory "foo"
    Then the directory "foo" should not exist

  Scenario: Just a dummy for reporting
    Given an empty file named "a/b.txt"
    Given an empty file named "a/b/c.txt"
    Given an empty file named "a/b/c/d.txt"

  Scenario: Change mode of empty file
    Given an empty file named "test.txt" with mode "0666"
    Then the mode of filesystem object "test.txt" should match "0666"

  Scenario: Change mode of a directory
    Given a directory named "test.d" with mode "0666"
    Then the mode of filesystem object "test.d" should match "0666"

  Scenario: Change mode of file
    Given a file named "test.txt" with mode "0666" and with:
    """
    asdf
    """
    Then the mode of filesystem object "test.txt" should match "0666"

  Scenario: Use a fixture
    Given I use a fixture named "fixtures-app"
    Then a file named "test.txt" should exist
