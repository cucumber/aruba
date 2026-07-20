@unsupported-on-platform-unix @unsupported-on-platform-mac
Feature: After command hooks

  You can configure Aruba to run blocks of code after it has run
  a command. The command will be passed to the block.

  You can hook into Aruba's lifecycle just before it runs a command and after it has run the command:

  ```ruby
  require 'aruba'

  Aruba.configure do |config|
    config.after :command do |cmd|
      puts "After the run of '#{cmd}'"
    end
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Run a simple command with an "after(:command)"-hook
    Given a file named "features/support/hooks.rb" with:
    """
    require_relative 'aruba'

    Aruba.configure do |config|
      config.after :command do |cmd|
        puts "after the run of `#{cmd.commandline}`"
      end
    end
    """
    And a file named "features/use_aruba_with_cucumber.feature" with:
    """
    Feature: Cucumber
      Scenario: First Run
        Given a file named "file.txt" with:
        \"\"\"
        Hello World
        \"\"\"
        When I successfully run `type file.txt`
        Then the output should contain:
        \"\"\"
        Hello World
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass
    And the output should contain:
    """
    after the run of `type file.txt`
    """
