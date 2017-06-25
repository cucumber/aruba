Feature: Return last command started

  Background:
    Given I use a fixture named "cli-app"

  Scenario: A command has been started
    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('echo hello') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started.commandline).to eq 'echo hello' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Multiple commands have been started
    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('echo hello') }
      before(:each) { run('echo world') }

      before(:each) { stop_all_commands }

      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started.commandline).to eq 'echo world' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: No command has been started
    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      it { expect{ last_command_started.commandline }.to raise_error Aruba::NoCommandHasBeenStartedError }
    end
    """
    When I run `rspec`
    Then the specs should all pass
