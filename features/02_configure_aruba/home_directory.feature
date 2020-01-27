Feature: Configure the home directory to be used with aruba

  As a developer
  I want to configure the home directory
  In order to have a better isolation of tests

  Be careful when you set the HOME-variable aka `config.home_directory` to something
  else than `<project_root>/tmp/aruba`. This is a dance with the devil and
  violates the isolation of your test suite. Thus will be not supported from
  aruba as of 1.0.0.

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      puts %(The default value is "#{config.home_directory}")
    end
    """
    When I successfully run `cucumber`
    Then the output should match:
    """
    The default value is "/.*/tmp/aruba"
    """

  Scenario: Set to current working directory
    Given a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      # use current working directory
      config.home_directory = '.'
    end

    Aruba.configure do |config|
      puts %(The value is "#{config.home_directory}")
    end
    """
    Then I successfully run `cucumber`
    Then the output should contain:
    """
    The value is "."
    """

  Scenario: Set a path inside aruba's working directory
    Given a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      # Use aruba working directory
      config.home_directory = File.join(config.root_directory,
                                        config.working_directory,
                                        "home")
    end

    Aruba.configure do |config|
      puts %(The value is "#{config.home_directory}")
    end
    """
    Then I successfully run `cucumber`
    Then the output should match:
    """
    The value is "/.*/tmp/aruba/home"
    """

  Scenario: Set to some other path (deprecated)
    Given a file named "features/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      # use current working directory
      config.home_directory = '/tmp/home'
    end

    Aruba.configure do |config|
      puts %(The value is "#{config.home_directory}")
    end
    """
    Then I successfully run `cucumber`
    Then the output should contain:
    """
    The value is "/tmp/home"
    """
