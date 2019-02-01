Feature: Access STDOUT of command

  You may need to `#stop_all_commands` before accessing `#stdout` of a single
  command - e.g. `#last_command_started`.

  Background:
    Given I use a fixture named "cli-app"
    And the default aruba io wait timeout is 1 seconds

  Scenario: Existing executable
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    echo 'Hello, Aruba!'
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run_command('aruba-test-cli') }
      before(:each) { stop_all_commands }
      it { expect(last_command_started.stdout).to start_with  'Hello' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Waiting for output to appear
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    sleep 0.1
    echo 'Hello, Aruba'
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :io_wait_timeout => 0.2 do
      before(:each) { run_command('aruba-test-cli') }
      it { expect(last_command_started.stdout).to start_with 'Hello' }
    end
    """
    When I run `rspec`
    Then the specs should all pass
