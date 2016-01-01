Feature: Delete existing environment variable via API-method

  It is quite handy to modify the environment of a process. To make this
  possible, `aruba` provides several methods. One of these is
  `#delete_environment_variable`. Using this remove an existing variable.

  Background:
    Given I use the fixture "cli-app"

  Scenario: Non-existing variable
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { delete_environment_variable 'LONG_LONG_VARIABLE' }

      before(:each) { run('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).not_to include 'LONG_LONG_VARIABLE=1' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Existing variable set from within the test
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { set_environment_variable 'LONG_LONG_VARIABLE', '1' }
      before(:each) { delete_environment_variable 'LONG_LONG_VARIABLE' }

      before(:each) { run('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).not_to include 'LONG_LONG_VARIABLE' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Existing variable set by some outer parent process

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    ENV['REALLY_LONG_LONG_VARIABLE'] = '1'

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { delete_environment_variable 'REALLY_LONG_LONG_VARIABLE' }

      before(:each) { run('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).not_to include 'REALLY_LONG_LONG_VARIABLE' }
    end
    """
    When I run `rspec`
    Then the specs should all pass
