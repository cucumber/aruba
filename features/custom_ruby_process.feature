Feature: Custom Ruby Process
  
  Running a lot of scenarios where each scenario uses Aruba
  to spawn a new ruby process can be time consuming.
  
  Aruba lets you plug in your own process class that can
  run a command in the same ruby process as Cucumber/Aruba.

  @in-process
  Scenario: Run a passing custom process
    When I run `reverse olleh dlrow`
    Then the output should contain "hello world"
