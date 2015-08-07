Feature: Usage of configuration

  You can configure `aruba` in two ways:

  1. Using `Aruba.configure`-block
  2. Using `aruba.config.<option> = <value>`

  The first (1.) should be used to set defaults for ALL your tests. It changes
  values on loadtime. The latter (2.) should be used to change options only for
  specific tests during runtime. `aruba.config` contains the runtime
  configuration of aruba which is reset to the loadtime configuration before
  each test is run.

  Background:
    Given I use a fixture named "cli-app"
    And an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    trap "exit 128" SIGTERM SIGINT
    sleep $*
    """

  Scenario: Setting default values for option for RSpec
    Given a file named "spec/support/aruba.rb" with:
    """ruby
    require 'aruba/rspec'

    Aruba.configure do |config|
      config.exit_timeout = 1
    end
    """
    And a file named "spec/usage_configuration_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      context 'when fast command' do
        before(:each) { run('cli 0') }
        it { expect(last_command_started).to be_successfully_executed }
      end

      context 'when slow command' do
        before(:each) { run('cli 2') }
        it { expect(last_command_started).not_to be_successfully_executed }
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Setting option during runtime for RSpec

    Maybe there are some long running tests, which need longer. You may not
    want to set the default timeout for all commands to the maximum value only
    to prevent those commands from failing.

    Given a file named "spec/support/aruba.rb" with:
    """ruby
    require 'aruba/rspec'

    Aruba.configure do |config|
      config.exit_timeout = 1
    end
    """
    And a file named "spec/support/hooks.rb" with:
    """ruby
    RSpec.configure do |config|
      config.before :each do |example|
        next unless example.metadata.key? :slow_command

        aruba.config.exit_timeout = 5
      end
    end
    """
    And a file named "spec/usage_configuration_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      context 'when fast command' do
        before(:each) { run('cli 0') }
        it { expect(last_command_started).to be_successfully_executed }
      end

      context 'when slow command and this is known by the developer', :slow_command => true do
        before(:each) { run('cli 2') }
        it { expect(last_command_started).to be_successfully_executed }
      end

      context 'when slow command, but this might be a failure' do
        before(:each) { run('cli 2') }
        it { expect(last_command_started).not_to be_successfully_executed }
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Setting default values for option for Cucumber
    Given a file named "features/support/aruba.rb" with:
    """ruby
    require 'aruba/cucumber'

    Aruba.configure do |config|
      config.exit_timeout = 1
    end
    """
    And a file named "features/run.feature" with:
    """
    Feature: Run it
      Scenario: Fast command
        When I run `cli 0`
        Then the exit status should be 0

      Scenario: Slow command
        When I run `cli 2`
        Then the exit status should be 128
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Setting option during runtime for Cucumber

    Maybe there are some long running tests, which need longer. You may not
    want to set the default timeout for all commands to the maximum value only
    to prevent those commands from failing.

    Given a file named "features/support/aruba.rb" with:
    """ruby
    require 'aruba/cucumber'

    Aruba.configure do |config|
      config.exit_timeout = 1
    end
    """
    And a file named "features/support/hooks.rb" with:
    """ruby
    Before '@slow-command' do
      aruba.config.exit_timeout = 5
    end
    """
    And a file named "features/usage_configuration.feature" with:
    """
    Feature: Run it
      Scenario: Fast command
        When I run `cli 0`
        Then the exit status should be 0

      @slow-command
      Scenario: Slow command known by the developer
        When I run `cli 2`
        Then the exit status should be 0

      Scenario: Slow command which might be a failure
        When I run `cli 3`
        Then the exit status should be 128
    """
    When I run `cucumber`
    Then the features should all pass
