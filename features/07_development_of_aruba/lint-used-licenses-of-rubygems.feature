Feature: Make sure only accepted licenses are used by dependencies

  As a aruba developer
  I want to build the `aruba` gem
  In order to install it

  Scenario: Only accepted licenses are used by dependencies

    When I successfully run `rake -T lint:licenses`
    Then the output should contain:
    """
    rake lint:licenses
    """
