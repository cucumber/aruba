Feature: Send running command a signal

  You can send a running command a signal using
  `last_command_started#send_signal`. This is only supported with
  `aruba.config.command_launcher = :spawn` (default).

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Existing executable
    Given an executable named "bin/cli" with:
    """ruby
    #!/usr/bin/env bash

    function hup {
      echo 'Exit...' >&2
      exit 0
    }

    trap hup HUP

    while [ true ]; do sleep 1; done
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 1, :startup_wait_time => 5 do
      before(:each) { run('cli') }
      before(:each) { last_command_started.send_signal 'HUP' }
      it { expect(last_command_started).to have_output /Exit/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Dying command
    Given an executable named "bin/cli" with:
    """ruby
    #!/usr/bin/env bash
    exit 1
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 1, :startup_wait_time => 5 do
      before(:each) { run('cli') }
      it { expect { last_command_started.send_signal 'HUP' }.to raise_error Aruba::CommandAlreadyStoppedError, /Command "cli" with PID/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass
