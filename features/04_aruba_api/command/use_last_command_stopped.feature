Feature: Return last command stopped

  Background:
    Given I use a fixture named "cli-app"

  Scenario: A command has been started
    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba do
      before { run_command('echo hello') }
      before { stop_all_commands }

      it { expect(last_command_stopped).to be_successfully_executed }
      it { expect(last_command_stopped.commandline).to eq 'echo hello' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Multiple commands have been started and all are stopped
    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba do
      before { run_command('echo hello') }
      before { run_command('echo world') }

      before { stop_all_commands }

      it { expect(last_command_stopped).to be_successfully_executed }
      it { expect(last_command_stopped.commandline).to eq 'echo world' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Multiple commands have been started and a single one is stopped
    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba do
      before { run_command('echo hello') }
      before { find_command('echo hello').stop }
      before { run_command('echo world') }

      it { expect(last_command_stopped).to be_successfully_executed }
      it { expect(last_command_stopped.commandline).to eq 'echo hello' }
    end
    """
    When I run `rspec`
    Then the specs should all pass


  Scenario: No command has been started
    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba do
      it { expect{ last_command_stopped.commandline }.to raise_error Aruba::NoCommandHasBeenStoppedError }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: No command has been stopped
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    while [ true ]; do sleep 0.1; done
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba, exit_timeout: 0.2 do
      before { run_command('aruba-test-cli') }

      it { expect{ last_command_stopped.commandline }.to raise_error Aruba::NoCommandHasBeenStoppedError }
    end
    """
    When I run `rspec`
    Then the specs should all pass
