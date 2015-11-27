Feature: Find a started command

  This feature is experimental and may change without further notice.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Existing command
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

  Scenario: Non-Existing command
    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      let(:command) { find_command('echo hello') }

      it { expect{ command }.to raise_error Aruba::CommandNotFoundError }
      it { expect{ command.commandline }.to raise_error Aruba::CommandNotFoundError }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Multiple commands
    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('echo hello1') }
      before(:each) { run('echo hello2') }
      let(:command) { find_command('echo hello1') }

      before(:each) { stop_all_commands }

      it { expect(command).to be_successfully_executed }
      it { expect(command.commandline).to eq 'echo hello1' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Multiple commands with same commandline

    If searches in reverse. So it finds the last command started with the given commandline.

    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { set_environment_variable 'ENV_VAR', '1' }
      before(:each) { run('bash -c "echo -n $ENV_VAR"') }
      before(:each) { set_environment_variable 'ENV_VAR', '2' }
      before(:each) { run('bash -c "echo -n $ENV_VAR"') }

      let(:command) { find_command('bash -c "echo -n $ENV_VAR"') }

      before(:each) { stop_all_commands }

      it { expect(command).to be_successfully_executed }
      it { expect(command.stdout).to eq '2' }
    end
    """
    When I run `rspec`
    Then the specs should all pass
