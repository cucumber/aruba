Feature: Output

  In order to specify expected output
  As a developer using Cucumber
  I want to use the "I should see" step

  Scenario: Detect output
    When I run ruby -e 'puts "hello world"'
    Then I should see "hello world"
