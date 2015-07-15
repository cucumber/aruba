Feature: Mock the HOME variable

  If you develop commandline applications, you might want to give your users
  the possibility to configure your program. Normally this is done via
  `.your-app-rc` or via `.config/your-app` an systems which comply to the
  freedesktop-specifications.

  To prevent to litter the developers HOME-directory `aruba` comes with a step
  which mocks the `HOME`-variable. It is set to the
  `aruba`-`working-directory`.

  Background:
    Given I use the fixture "cli-app"
    And an executable named "bin/cli" with:
    """
    #!/bin/bash

    echo "HOME: $HOME"
    """

  Scenario: Mocked home directory by using a step
    Given a file named "features/home_variable.feature" with:
    """
    Feature: Home Variable
      Scenario: Run command
        Given a mocked home directory
        When I run `cli`
        Then the output should match %r<HOME:.*tmp/aruba$>
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Mocked home directory by using a tag
    Given a file named "features/home_variable.feature" with:
    """
    Feature: Home Variable
      @mocked-home-directory
      Scenario: Run command
        When I run `cli`
        Then the output should match %r<HOME:.*tmp/aruba$>
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Redefine home directory by using the aruba configuration
    Given a file named "features/support/home_variable.rb" with:
    """
    require 'aruba/cucumber'

    Aruba.configure do |config|
      config.home_directory = File.join(config.root_directory, config.working_directory)
    end
    """
    Given a file named "features/home_variable.feature" with:
    """
    Feature: Home Variable
      Scenario: Run command
        When I run `cli`
        Then the output should match %r<HOME:.*tmp/aruba$>
    """
    When I run `cucumber`
    Then the features should all pass
