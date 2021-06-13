Feature: Send running command a signal

  You can send a running command a signal using
  `Command#send_signal`. This is only supported with
  `aruba.config.command_launcher = :spawn` (default).

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Existing executable
    Given an executable named "bin/aruba-test-cli" with:
    """bash
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

    RSpec.describe 'send_signal', type: :aruba, exit_timeout: 1, startup_wait_time: 0.3 do
      it "sends the signal to the command" do
        command = run_command('aruba-test-cli')
        command.send_signal 'HUP'
        expect(command).to have_output /Exit/
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
