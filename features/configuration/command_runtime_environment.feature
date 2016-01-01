Feature: Define default process environment
  Say you want to have a default set of environment variables, then use this
  code.

  ~~~ruby
  Aruba.configure do |config|
    config.command_runtime_environment = { 'MY_VARIABLE' => 'x' }
  end
  ~~~

  This can be changed via `#set_environment_variable`,
  `#append_environment_variable`, `#delete_environment_variable` or
  `#prepend_environment_variable`.

  Background:
    Given I use the fixture "cli-app"

  Scenario: Overwrite existing variable with new default value
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    ENV['LONG_LONG_VARIABLE'] = 'y'

    Aruba.configure do |config|
      config.command_runtime_environment = { 'LONG_LONG_VARIABLE' => 'x' } 
    end

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { run('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=x' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Overwrite default value for variable
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    ENV['LONG_LONG_VARIABLE'] = 'y'

    Aruba.configure do |config|
      config.command_runtime_environment = { 'LONG_LONG_VARIABLE' => 'x' } 
    end

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { set_environment_variable 'LONG_LONG_VARIABLE', 'z' }

      before(:each) { run('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=z' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Append value to default value
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    ENV['LONG_LONG_VARIABLE'] = 'y'

    Aruba.configure do |config|
      config.command_runtime_environment = { 'LONG_LONG_VARIABLE' => 'x' } 
    end

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { append_environment_variable 'LONG_LONG_VARIABLE', 'z' }

      before(:each) { run('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=xz' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Prepend value
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    ENV['LONG_LONG_VARIABLE'] = 'y'

    Aruba.configure do |config|
      config.command_runtime_environment = { 'LONG_LONG_VARIABLE' => 'x' } 
    end

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { prepend_environment_variable 'LONG_LONG_VARIABLE', 'z' }

      before(:each) { run('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=zx' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Remove variable from default set of variables
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    ENV['LONG_LONG_VARIABLE'] = 'y'

    Aruba.configure do |config|
      config.command_runtime_environment = { 'LONG_LONG_VARIABLE' => 'x' } 
    end

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { delete_environment_variable 'LONG_LONG_VARIABLE' }

      before(:each) { run('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).not_to include 'LONG_LONG_VARIABLE' }
    end
    """
    When I run `rspec`
    Then the specs should all pass
