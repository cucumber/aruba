Feature: Check if a timeout occured during command execution

  Scenario: Check if command finishes in time
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    exit 0
    """
    And a file named "spec/timeout_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Short running command', :type => :aruba do
      before(:each) { aruba.config.exit_timeout = 5 }

      before(:each) { run_command('aruba-test-cli') }

      it { expect(last_command_started).to have_finished_in_time }
    end
    """
    When I run `rspec`
    Then the specs should all pass
