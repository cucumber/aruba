Feature: exit statuses

  In order to specify expected exit statuses
  As a developer using Cucumber
  I want to use the "the exit status should be" step

  Scenario: exit status of 0
    When I run `true`
    Then the exit status should be 0

  Scenario: non-zero exit status
    When I run `false`
    Then the exit status should be 1
    And the exit status should not be 0

  Scenario: Successfully run something
    When I successfully run `true`

  Scenario: Unsuccessfully run something
    When I do aruba I successfully run `false`
    Then aruba should fail with ""
