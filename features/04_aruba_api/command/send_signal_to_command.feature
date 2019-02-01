Feature: Send running command a signal

  You can send a running command a signal using
  `last_command_started#send_signal`. This is only supported with
  `aruba.config.command_launcher = :spawn` (default).

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Existing executable
    Given an executable named "bin/aruba-test-cli" with:
    """ruby
    #!/usr/bin/env bash

    function hup {
      echo 'Exit...' >&2
      exit 0
    }

    trap hup HUP

    while [ true ]; do sleep 0.1; done
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 1, :startup_wait_time => 0.1 do
      before(:each) { run_command('aruba-test-cli') }
      before(:each) { last_command_started.send_signal 'HUP' }
      it { expect(last_command_started).to have_output /Exit/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Dying command
    Given an executable named "bin/aruba-test-cli" with:
    """ruby
    #!/usr/bin/env bash
    exit 1
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 1, :startup_wait_time => 0.1 do
      before(:each) { run_command('aruba-test-cli') }
      it { expect { last_command_started.send_signal 'HUP' }.to raise_error Aruba::CommandAlreadyStoppedError, /Command "aruba-test-cli" with PID/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass
