Feature: Terminate all commands

  To terminate all running commands use the `#terminate_all_commands`-method.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Multiple commands are running
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    sleep 0.4
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'terminating commands', type: :aruba, exit_timeout: 0.4 do
      before do
        run_command('aruba-test-cli')
        run_command('aruba-test-cli')
      end

      it 'stops all commands' do
        terminate_all_commands
        expect(all_commands).to all be_stopped
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Terminate all commands for which the block returns true
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    sleep 0.4
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba, exit_timeout: 0.4 do
      before do
        @cmd1 = run_command('aruba-test-cli')
        @cmd2 = run_command('aruba-test-cli')
        @cmd3 = run_command('sleep 0.4')
      end

      it 'only terminates selected commands' do
        terminate_all_commands { |c| c.commandline == 'aruba-test-cli' }

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
