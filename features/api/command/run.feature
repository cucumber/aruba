Feature: Run command

  To run a command use the `#run`-method.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Existing executable
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    exit 0
    """
    And a file named "spec/which_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      it { expect(last_command).to be_successfully_executed }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Non-existing executable
    Given a file named "bin/cli" does not exist
    And a file named "spec/which_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Find path for command', :type => :aruba do
      it { expect { run('cli') }.to raise_error Aruba::LaunchError, /Command "cli" not found in PATH-variable/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass
