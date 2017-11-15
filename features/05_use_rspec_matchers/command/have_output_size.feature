Feature: Check command has output of size

  The matcher sanitizes the output of your command before checking the output
  size.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Check if command output has expected size
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    echo string
    """
    And a file named "spec/output_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Command with output', :type => :aruba do
      before(:each) { run_command('aruba-test-cli') }

      it { expect(last_command_started).to have_output_size 6 }
    end
    """
    When I run `rspec`
    Then the specs should all pass
