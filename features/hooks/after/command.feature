Feature: After command hooks

  You can configure Aruba to run blocks of code after it has run
  a command. The command will be passed to the block.

  You can hook into Aruba's lifecycle just before it runs a command and after it has run the command:

  ```ruby
  Aruba.configure do |config|
    config.after :command do |cmd|
      puts "After the run of '#{cmd}'"
    end
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Run a simple command with an "after(:command)"-hook
    Given a file named "spec/support/hooks.rb" with:
    """
    require 'aruba'

    Aruba.configure do |config|
      config.after :command do |cmd|
        puts "after the run of `#{cmd.commandline}`"
      end
    end
    """
    And a file named "spec/hook_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Hooks', :type => :aruba do
      before(:each) { run_simple 'echo running' }

      it { expect(last_command_started.stdout.chomp).to eq 'running' }
    end
    """
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    after the run of `echo running`
    """

