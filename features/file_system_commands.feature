Feature: file system commands

  In order to specify commands that load files
  As a developer using Cucumber
  I want to create temporary files
  
  Scenario: create a dir
    Given a directory named "foo/bar"
    When I run "ruby -e \"puts test ?d, 'foo'\""
    Then the stdout should contain "true"
  
  Scenario: cat a file
    Given a file named "foo/bar/example.rb" with:
      """
      puts "hello world"
      """
    When I run "ruby foo/bar/example.rb"
    Then I should see "hello world"

  Scenario: clean up files generated in previous scenario
    When I run "ruby foo/bar/example.rb"
    Then the exit status should be 1
    And I should see "No such file or directory -- foo/bar/example.rb"
  
  Scenario: change to a subdir
    Given a file named "foo/bar/example.rb" with:
      """
      puts "hello world"
      """
    When I cd to "foo/bar"
    And I run "ruby example.rb"
    Then I should see "hello world"

  Scenario: Reset current directory from previous scenario
    When I run "ruby example.rb"
    Then the exit status should be 1

  @fail
  Scenario: Holler if cd to bad dir
    Given a file named "foo/bar/example.rb" with:
      """
      puts "hello world"
      """
    When I cd to "foo/nonexistant"
