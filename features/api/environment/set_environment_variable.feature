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

  Scenario: Non-existing variable
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { set_environment_variable 'LONG_LONG_VARIABLE', '1' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=1' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Existing variable set from within the test
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { set_environment_variable 'LONG_LONG_VARIABLE', '1' }
      before(:each) { set_environment_variable 'LONG_LONG_VARIABLE', '2' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=2' }
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
      before(:each) { set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '2' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'REALLY_LONG_LONG_VARIABLE=2' }
      it { expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Set variable via ENV

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { ENV['REALLY_LONG_LONG_VARIABLE'] = '2' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'REALLY_LONG_LONG_VARIABLE=2' }
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
      before(:each) { set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '1' }
      before(:each) { ENV['REALLY_LONG_LONG_VARIABLE'] = '2' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'REALLY_LONG_LONG_VARIABLE=1' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Run some ruby code in code with previously set environment

    The `#with_environment`-block makes the change environment temporary
    avaiable for the code run within the block.

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    ENV['REALLY_LONG_LONG_VARIABLE'] = '1'

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '2' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it do
        with_environment do
          expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '2'
        end
      end

      it { expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1' }

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

    ENV['REALLY_LONG_LONG_VARIABLE'] = '1'

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '2' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it do
        with_environment 'REALLY_LONG_LONG_VARIABLE' => '3' do
          expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '3'
        end
      end

      it { expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Nested setup with rspec

    It doesn't matter if you define an environment variable in some outer
    scope, when you are using `RSpec`.

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { set_environment_variable 'LONG_LONG_VARIABLE', '1' }

      describe 'Method XX' do
        before(:each) { run_command('env') }
        before(:each) { stop_all_commands }

        it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=1' }
      end

      describe 'Method YY' do
        before(:each) { set_environment_variable 'LONG_LONG_VARIABLE', '2' }

        before(:each) { run_command('env') }
        before(:each) { stop_all_commands }

        it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=2' }
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: When an error occures the ENV is not polluted
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    ENV['REALLY_LONG_LONG_VARIABLE'] = '1'

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) { set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '2' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it do
        begin
          with_environment 'REALLY_LONG_LONG_VARIABLE' => '3' do
            fail
          end
        rescue StandardError
        end

        expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1'
      end

      it { expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1' }
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

    ENV['LONG_LONG_VARIABLE'] = '1'
    ENV['REALLY_LONG_LONG_VARIABLE'] = '1'

    RSpec.describe 'Environment command', :type => :aruba do
      it do
        with_environment 'REALLY_LONG_LONG_VARIABLE' => 2 do
          with_environment 'LONG_LONG_VARIABLE' => 3 do
            expect(ENV['LONG_LONG_VARIABLE']).to eq '3'
            expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '2'
          end
        end
      end

      it { expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Re-use `#with_environment` for multiple `RSpec`-`it`-blocks

    If you chose to run wrap examples via `RSpec`'s `around`-hook, make sure you
    use `before(:context) {}` instead of `before(:each)` to set an environment
    variable. Only then the `before`-hook is run before the `around`-hook is
    run.

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Environment command', :type => :aruba do
      # Please mind :context. This is run BEFORE the `around`-hook
      before(:context) { set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '1' }

      context 'when no arguments are given' do
        around(:each) do |example|
          with_environment do
            example.run
          end
        end

        it { expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1' }

        before(:each) { run_command('env') }
        before(:each) { stop_all_commands }

        it { expect(last_command_started.output).to include 'REALLY_LONG_LONG_VARIABLE=1' }
      end

      context 'when arguments given' do
        around(:each) do |example|
          with_environment 'LONG_LONG_VARIABLE' => 2 do
            example.run
          end
        end

        it { expect(ENV['LONG_LONG_VARIABLE']).to eq '2' }

        before(:each) { run_command('env') }
        before(:each) { stop_all_commands }

        it { expect(last_command_started.output).to include 'REALLY_LONG_LONG_VARIABLE=1' }
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
      before(:each) { set_environment_variable 'long_LONG_VARIABLE', '1' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

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
      before(:each) { set_environment_variable 'long_LONG_VARIABLE', '1' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=1' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: External ruby file / ruby gem modifying ENV

    There are some Rubygems around which need to modify ENV['NODE_PATH'] like
    [`ruby-stylus`](https://github.com/forgecrafted/ruby-stylus/blob/e7293362dc8cbf550f7c317d721ba6b9087e8833/lib/stylus.rb#L168).
    This is supported by aruba as well.

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    $LOAD_PATH <<  File.expand_path('../../lib', __FILE__)

    RSpec.describe 'Environment command', :type => :aruba do
      before(:each) do
        require 'my_library'
      end

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=1' }
    end
    """
    And a file named "lib/my_library.rb" with:
    """
    ENV['LONG_LONG_VARIABLE'] = '1'
    """
    When I run `rspec`
    Then the specs should all pass
