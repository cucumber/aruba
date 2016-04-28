Feature: Build Aruba Gem

  As a aruba developer
  I want to build the `aruba` gem
  In order to install it

  Scenario: Building aruba using rake task

    To build the `aruba`-gem you can use the `build`-rake task.

    Given I successfully run `rake -T build`
    Then the output should contain:
    """
    build
    """
