Feature: before_cmd hooks

  You can configure Aruba to run blocks of code before it runs
  each command.

  The command will be passed to the block.

  You can hook into Aruba's lifecycle just before it runs a command and after it has run the command:

  ```ruby
  Aruba.configure do |config|
    config.before :command do |cmd|
      puts "About to run '#{cmd}'"
    end
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Run a simple command with a "before(:command)"-hook
    Given a file named "spec/support/hooks.rb" with:
    """
    require 'aruba'

    Aruba.configure do |config|
      config.before :command do |cmd|
        puts "before the run of `#{cmd.commandline}`"
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
    before the run of `echo running`
    """

  Scenario: Run a simple command with a "before(:cmd)"-hook (deprecated)
    Given a file named "spec/support/hooks.rb" with:
    """
    require 'aruba'

    Aruba.configure do |config|
      config.before :cmd do |cmd|
        puts "before the run of `#{cmd}`"
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
    before the run of `echo running`
    """
