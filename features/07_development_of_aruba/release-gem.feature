Feature: Release gem

  As a aruba developer
  I want to build the `aruba` gem
  In order to install it

  Scenario: Release gem

    When I successfully run `rake -T gem:release`
    Then the output should contain:
    """
    rake rubygem:release
    """
