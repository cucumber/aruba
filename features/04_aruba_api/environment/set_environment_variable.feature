Feature: Set environment variable via API-method

  It is quite handy to modify the environment of a process. To make this
  possible, `aruba` provides several methods. One of these is
  `#set_environment_variable`. Using this sets the value of a
  non-existing variable and overwrites an existing value. Each variable name
  and each value is converted to a string. Otherwise `ruby` would complain
  about an invalid argument. To make use of a variable you can either use `#run`
  and the like or `#with_environment`. Besides setting a variable globally, you
  can set one for a block of code only using `#with_environment`.

  Background:
    Given I use the fixture "cli-app"

  Scenario: Setting a new variable
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'running env', :type => :aruba do
      before do
        set_environment_variable 'LONG_LONG_VARIABLE', '1'

        run_command('env')
        stop_all_commands
      end

      it "outputs the value set and restores the original" do
        expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=1'
        expect(ENV['LONG_LONG_VARIABLE']).to be_nil
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Overriding a previously set variable
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'running env', :type => :aruba do
      before do
        set_environment_variable 'LONG_LONG_VARIABLE', '1'
        set_environment_variable 'LONG_LONG_VARIABLE', '2'

        run_command('env')
        stop_all_commands
      end

      it "outputs the last values set" do
        expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=2'
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass


  Scenario: Updating a variable previously set via ENV

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    ENV['REALLY_LONG_LONG_VARIABLE'] = '1'

    RSpec.describe 'running env', :type => :aruba do
      before do
        set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '2'

        run_command('env')
        stop_all_commands
      end

      it "outputs the value set and restores the original" do
        expect(last_command_started.output).to include 'REALLY_LONG_LONG_VARIABLE=2'
        expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1'
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Set variable via ENV

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Environment command', :type => :aruba do
      before do
        ENV['REALLY_LONG_LONG_VARIABLE'] = '2'

        run_command('env')
        stop_all_commands
      end

      it "outputs the value set and keeps it" do
        expect(last_command_started.output).to include 'REALLY_LONG_LONG_VARIABLE=2'
        expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '2'
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Existing variable set in before block in RSpec

    Setting environment variables with `#set_environment_variable('VAR', 'value')` takes
    precedence before setting variables with `ENV['VAR'] = 'value'`.

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Environment command', :type => :aruba do
      before do
        set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '1'
        ENV['REALLY_LONG_LONG_VARIABLE'] = '2'

        run_command('env')
        stop_all_commands
      end

      it "outputs the value set by #set_environment_variable" do
        expect(last_command_started.output).to include 'REALLY_LONG_LONG_VARIABLE=1'
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Run some ruby code in code with previously set environment

    The `#with_environment`-block makes the changed environment temporarily
    available for the code run within the block.

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Environment command', :type => :aruba do
      before do
        ENV['REALLY_LONG_LONG_VARIABLE'] = '1'
        set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '2'
      end

      it do
        with_environment do
          expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '2'
        end
        expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1'
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Run some ruby code with local environment

    If you need to set some environment variables only for the given block.
    Pass it an `Hash` containing the environment variables.

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Environment command', :type => :aruba do
      before do
        ENV['REALLY_LONG_LONG_VARIABLE'] = '1'

        set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '2'
      end

      it do
        with_environment 'REALLY_LONG_LONG_VARIABLE' => '3' do
          expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '3'
        end
        expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1'
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: When an error occures the ENV is not polluted
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Environment command', :type => :aruba do
      before do
        ENV['REALLY_LONG_LONG_VARIABLE'] = '1'

        set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '2'
      end

      it do
        begin
          with_environment 'REALLY_LONG_LONG_VARIABLE' => '3' do
            fail
          end
        rescue StandardError
        end

        expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1'
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Run some ruby code with nested environment blocks

    It is possible to use a `#with_environment`-block with a
    `#with_environment`-block. Each previously set variable is available with
    the most inner block.

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'


    RSpec.describe 'Environment command', :type => :aruba do
      before do
        ENV['LONG_LONG_VARIABLE'] = '1'
        ENV['REALLY_LONG_LONG_VARIABLE'] = '1'
      end

      it do
        with_environment 'REALLY_LONG_LONG_VARIABLE' => 2 do
          with_environment 'LONG_LONG_VARIABLE' => 3 do
            expect(ENV['LONG_LONG_VARIABLE']).to eq '3'
            expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '2'
          end
        end

        expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1'
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  @unsupported-on-platform-windows
  Scenario: Mixed-Case variable
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Environment command', :type => :aruba do
      before { set_environment_variable 'long_LONG_VARIABLE', '1' }

      before { run_command('env') }
      before { stop_all_commands }

      it { expect(last_command_started.output).to include 'long_LONG_VARIABLE=1' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  @unsupported-on-platform-unix
  @unsupported-on-platform-mac
  Scenario: Mixed-Case variable
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Environment command', :type => :aruba do
      before { set_environment_variable 'long_LONG_VARIABLE', '1' }

      before { run_command('env') }
      before { stop_all_commands }

      it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=1' }
    end
    """
    When I run `rspec`
    Then the specs should all pass
