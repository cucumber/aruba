Feature: Check if a timeout occured during command execution

  If you want to check if a command takes too long to finish its work, you can
  use the `run_too_long` and `have_finished_in_time` matchers.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Check if command runs too long
    Given a file named "spec/timeout_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Long running command', type: :aruba do
      before { aruba.config.exit_timeout = 0.1 }

      it "runs too long" do
        slow_command = which('sleep') ? 'sleep 0.2' : 'timeout 2'
        run_command slow_command
        expect(last_command_started).to run_too_long
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Check if command finishes in time
    Given a file named "spec/timeout_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Short running command', type: :aruba do
      before { aruba.config.exit_timeout = 5 }

      it "is done quickly" do
        run_command('echo "Fast!"')

        expect(last_command_started).to have_finished_in_time
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
