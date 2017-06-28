Feature: Run test suite

  As a aruba developer
  I want to run the test suite of the `aruba` gem
  In order to check my changed code

  Scenario: Run unit tests with `rspec`

    When I successfully run `rake -T test:rspec`
    Then the output should contain:
    """
    rake test:rspec
    """

  Scenario: Run acceptance tests with `cucumber`

    This task is for fully implemented features.

    When I successfully run `rake -T test:cucumber`
    Then the output should contain:
    """
    rake test:cucumber
    """

  Scenario: Run acceptance tests with `cucumber` for features which are under active development

    This task is for running tests for features which are Work in Progress and therefore might fail the suite.

    When I successfully run `rake -T test:cucumber_wip`
    Then the output should contain:
    """
    rake test:cucumber
    """

  Scenario: Run whole test suite via rake

    When I successfully run `rake -T test`
    Then the output should contain:
    """
    rake test
    """

  @ignore
  Scenario: Run whole test suite via "test"-script

    When I successfully run `script/test`
    Then the output should contain:
    """
    rake test
    """
