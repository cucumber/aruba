Feature: Stop command

  To stop commands via API you can do the following:

  - `last_command_started.stop`
  - `stop_all_commands`

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Stop successful command with configured signal
    Given an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    function hup {
      echo "Exit..."
      exit 0
    }

    function term {
      echo "No! No exit here. Try HUP. I stop the command with exit 1."
      exit 1
    }

    trap hup HUP
    trap term TERM
    while [ true ]; do sleep 1; done
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    Aruba.configure do |config|
      config.stop_signal  = 'HUP'
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
    function hup {
      echo "Exit..."
      exit 2
    }

    function term {
      echo "No! No exit here. Try HUP. I stop the command with exit 1."
      exit 1
    }

    trap hup HUP
    trap term TERM
    while [ true ]; do sleep 1; done
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    Aruba.configure do |config|
      config.stop_signal  = 'HUP'
      config.exit_timeout = 1
    end

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      it { expect(last_command_started).to have_exit_status 2 }
    end
    """
    When I run `rspec`
    Then the specs should all pass
