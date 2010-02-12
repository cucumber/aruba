Feature: file system commands

  In order to specify commands that load files
  As a developer using Cucumber
  I want to create temporary files
  
  Scenario: cat a file
    Given a file named "example.rb" with:
      """
      puts "hello world"
      """
    When I run ruby example.rb
    Then I should see "hello world"

  