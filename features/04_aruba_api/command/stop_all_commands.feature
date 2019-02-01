Feature: Stop all commands

  To stop all running commands use the `#stop_all_commands`-method.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Multiple commands are running
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    sleep 0.2
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 0.3 do
      before(:each) { run_command('aruba-test-cli') }
      before(:each) { run_command('aruba-test-cli') }

      before(:each) { stop_all_commands }

      it { expect(all_commands).to all be_stopped }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Stop all commands for which the block returns true
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    sleep 0.1
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 0.2 do
      before(:each) { @cmd1 = run_command('aruba-test-cli') }
      before(:each) { @cmd2 = run_command('aruba-test-cli') }
      before(:each) { @cmd3 = run_command('sleep 1') }

      before(:each) { stop_all_commands { |c| c.commandline == 'aruba-test-cli' } }

      it 'only stops selected commands' do
        aggregate_failures do
          expect(@cmd1).to be_stopped
          expect(@cmd2).to be_stopped
          expect(@cmd3).not_to be_stopped
        end
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
