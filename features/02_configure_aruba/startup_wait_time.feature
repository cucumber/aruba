Feature: Set time to wait after spawning command

  As a developer
  I want to configure a time span to wait after the command was spawned
  In order to prevent failure of some commands which take a little bit longer
  to load.


  If you setup a ruby script, this may load bundler. This makes the script to
  start up a little bit longer. If you want to run a command in background,
  starting the command in a background process may take longer then sending it
  a signal.

  If you experience some brittle tests with background commands, try to set the
  `#startup_wait_time`.

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      puts %(The default value is "#{config.startup_wait_time}")
    end
    """
    When I successfully run `cucumber`
    Then the output should contain:
    """
    The default value is "0"
    """

  Scenario: Modify value
    Given a file named "features/support/aruba.rb" with:
    """ruby
    Aruba.configure do |config|
      config.startup_wait_time = 2
    end

    Aruba.configure do |config|
      puts %(The new value is "#{config.startup_wait_time}")
    end
    """
    Then I successfully run `cucumber`
    Then the output should contain:
    """
    The new value is "2"
    """
