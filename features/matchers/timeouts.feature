Feature: Check if a timeout occured during command execution

  If you want to check if a command takes to long to finish it's work

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Check if command runs to long
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    sleep 1
    """
    And a file named "spec/timeout_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { aruba.config.exit_timeout = 0 }

      before(:each) { run('cli') }

      it { expect(last_command_started).to run_too_long }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Check if command finishes in time
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    exit 0
    """
    And a file named "spec/timeout_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Short running command', :type => :aruba do
      before(:each) { aruba.config.exit_timeout = 5 }

      before(:each) { run('cli') }

      it { expect(last_command_started).to have_finished_in_time }
    end
    """
    When I run `rspec`
    Then the specs should all pass
