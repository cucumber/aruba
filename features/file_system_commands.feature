Feature: file system commands

  In order to specify commands that load files
  As a developer using Cucumber
  I want to create temporary files
  
  Scenario: cat a file
    Given a file named "foo/bar/example.rb" with:
      """
      puts "hello world"
      """
    When I run "ruby foo/bar/example.rb"
    Then I should see "hello world"

  Scenario: clean up dude
    When I run "ruby foo/bar/example.rb"
    Then the exit status should be 1
    And I should see "No such file or directory -- foo/bar/example.rb"
    