Feature: Install gem

  As a aruba contributor
  I want to build the `aruba` gem
  In order to install it

  Scenario: Install gem locally

    When I successfully run `rake -T gem:install`
    Then the output should contain:
    """
    rake rubygem:install
    """
    And the output should contain:
    """
    rake rubygem:install:local
    """

