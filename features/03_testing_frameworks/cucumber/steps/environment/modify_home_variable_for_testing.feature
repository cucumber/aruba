Feature: Mock the HOME variable

  If you develop command line applications, you might want to give your users
  the possibility to configure your program. Normally this is done via
  `.your-app-rc` or via `.config/your-app` an systems which comply to the
  freedesktop-specifications.

  To prevent to litter the developers HOME-directory `aruba` sets the
  `HOME`-variable automatically.

  Background:
    Given I use the fixture "cli-app"
    And an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash

    echo "HOME: $HOME"
    """

  Scenario: Home directory is automatically mocked
    Given a file named "features/home_variable.feature" with:
    """
    Feature: Home Variable
      Scenario: Run command
        When I run `aruba-test-cli`
        Then the output should match %r<HOME:.*tmp/aruba$>
    """
    When I run `cucumber`
    Then the features should all pass
