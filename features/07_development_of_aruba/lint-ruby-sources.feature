Feature: Lint Ruby sources

  As a aruba contributor
  I want to lint the modified ruby sources
  In order to be compliant to the code guidelines

  Scenario: Existing rake task
    When I successfully run `rake -T lint:coding_guidelines`
    Then the output should contain:
    """
    rake lint:coding_guidelines
    """
