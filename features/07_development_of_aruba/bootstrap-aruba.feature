Feature: Bootstrap "aruba"

  As a aruba contributor
  I want to bootstrap the `aruba` project
  In order to start working on it

  Scenario: Run the bootstrap script

    When I successfully run `script/bootstrap`
    Then the output should contain:
    """
    [INFO] Checking if ruby installed? OK
    """
    And the output should contain:
    """
    [INFO] rubygem "bundler"
    """
    And the output should contain:
    """
    [INFO] "bundle install"
    """
