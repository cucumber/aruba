Feature: Lint travis configuration

  As a aruba developer
  I want to build the `aruba` gem
  In order to install it

  Scenario: Valid travis configuration file

    When I successfully run `rake -T lint:travis`
    Then the output should contain:
    """
    lint:travis
    """
