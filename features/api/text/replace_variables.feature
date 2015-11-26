@experimental
Feature: Replace variables

  There are use cases where you need access to some information from aruba in
  your command line. The `#replace_variables`-method makes this information
  available.

  Please note, this feature is experimental for now. The implementation of this
  feature and the name of variables may change without further notice.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: PID of last command started
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    exit 0
    """
    And a file named "spec/replace_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      before(:each) { stop_all_commands }
 
      it { expect(replace_variables('<pid-last-command-started>')).to eq last_command_started.pid.to_s }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: No last command started
    Given a file named "spec/replace_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      it { expect { replace_variables('<pid-last-command-started>') }.to raise_error Aruba::NoCommandHasBeenStartedError }
    end
    """
    When I run `rspec`
    Then the specs should all pass

