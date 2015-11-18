Feature: Run command

  To run a command use the `#run`-method.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Existing executable
    Given an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    exit 0
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      it { expect(last_command_started).to be_successfully_executed }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Relative path to executable
    Given an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    exit 0
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('bin/cli') }
      it { expect(last_command_started).to be_successfully_executed }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Non-existing executable
    Given a file named "bin/cli" does not exist
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Find path for command', :type => :aruba do
      it { expect { run('cli') }.to raise_error Aruba::LaunchError, /Command "cli" not found in PATH-variable/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Stop successful command with configured signal
    Given an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    function usr1 {
      echo "Exit..."
      exit 0
    }

    function term {
      echo "No! No exit here. Try USR1. I stop the command with exit 1."
      exit 1
    }

    trap usr1 USR1
    trap term TERM
    while [ true ]; do sleep 1; done
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    Aruba.configure do |config|
      config.stop_signal  = 'USR1'
      config.exit_timeout = 1
    end

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      it { expect(last_command_started).to be_successfully_executed }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Stop unsuccessful command with configured signal
    Given an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    function usr1 {
      echo "Exit..."
      exit 2
    }

    function term {
      echo "No! No exit here. Try USR1. I stop the command with exit 1."
      exit 1
    }

    trap usr1 USR1
    trap term TERM
    while [ true ]; do sleep 1; done
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    Aruba.configure do |config|
      config.stop_signal  = 'USR1'
      config.exit_timeout = 1
    end

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      it { expect(last_command_started).to have_exit_status 2 }
    end
    """
    When I run `rspec`
    Then the specs should all pass
