Feature: Send running command a signal

  You can send a running command a signal using
  `last_command_started#send_signal`. This is only supported with
  `aruba.config.command_launcher = :spawn` (default).

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Existing executable
    Given an executable named "bin/cli" with:
    """ruby
    #!/usr/bin/env ruby

    $stderr.puts 'Now I run the code'

    Signal.trap 'USR1' do
      $stderr.puts 'Exit...'
      exit 0
    end

    loop { sleep 1 }
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 3, :startup_wait_time => 2 do
      before(:each) { run('cli') }
      before(:each) { last_command_started.send_signal 'USR1' }
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

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 3, :startup_wait_time => 2 do
      before(:each) { run('cli') }
      it { expect { last_command_started.send_signal 'HUP' }.to raise_error Aruba::CommandAlreadyStoppedError, /Command "cli" with PID/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass
