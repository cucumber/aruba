Feature: Find a started command

  Scenario: Exising command
    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('echo hello') }
      let(:command) { find_command('echo hello') }

      before(:each) { stop_all_commands }

      it { expect(command).to be_successfully_executed }
      it { expect(command.commandline).to eq 'echo hello' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Non-Exising command
    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      let(:command) { find_command('echo hello') }

      it { expect{ command }.to raise_error Aruba::CommandNotFound }
      it { expect{ command.commandline }.to raise_error Aruba::CommandNotFound }
    end
    """
    When I run `rspec`
    Then the specs should all pass
