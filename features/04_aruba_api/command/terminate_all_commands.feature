Feature: Terminate all commands

  To terminate all running commands use the `#terminate_all_commands`-method.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Multiple commands are running
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    sleep 3
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 5 do
      before(:each) { run_command('aruba-test-cli') }
      before(:each) { run_command('aruba-test-cli') }

      before(:each) { terminate_all_commands }

      it { expect(all_commands).to all be_stopped }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Terminate all commands for which the block returns true
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    sleep 0.5
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 1 do
      before(:each) { @cmd1 = run_command('aruba-test-cli') }
      before(:each) { @cmd2 = run_command('aruba-test-cli') }
      before(:each) { @cmd3 = run_command('sleep 1') }

      before(:each) { terminate_all_commands { |c| c.commandline == 'aruba-test-cli' } }

      it 'only terminates selected commands' do
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
