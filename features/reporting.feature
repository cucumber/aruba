Feature: Reporting

  Aruba can generate a HTML page for each scenario that contains:
  - The title of the scenario
  - The description from the scenario (You can use Markdown here)
  - The command(s) that were run
  - The output from those commands (in colour if the output uses ANSI escapes)
  - The files that were created (syntax highlighted in in colour)

  @wip-jruby-java-1.6
  Scenario: Running a simple Aruba feature with reporting on should not error
    When I run `cucumber ../../features/before_cmd_hooks.feature ARUBA_REPORT_DIR=doc`
    Then the exit status should be 0
