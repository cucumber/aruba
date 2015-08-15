Feature: Stop all commands

  To stop all running commands use the `#stop_all_commands`-method.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Multiple commands are running
    Given an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    sleep 3
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 5 do
      before(:each) { run('cli') }
      before(:each) { run('cli') }

      before(:each) { stop_all_commands }

      it { expect(all_commands).to all be_stopped }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Stop all commands for which the block returns true
    Given an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    sleep 1
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 2 do
      before(:each) { @cmd1 = run('cli') }
      before(:each) { @cmd2 = run('cli') }
      before(:each) { @cmd3 = run('sleep 1') }

      before(:each) { stop_all_commands { |c| c.commandline == 'cli' } }

      it { expect(@cmd1).to be_stopped }
      it { expect(@cmd2).to be_stopped }
      it { expect(@cmd3).not_to be_stopped }
    end
    """
    When I run `rspec`
    Then the specs should all pass
