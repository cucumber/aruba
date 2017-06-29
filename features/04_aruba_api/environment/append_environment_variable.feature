Feature: Append environment variable

  It is quite handy to modify the environment of a process. To make this
  possible, `aruba` provides several methods. One of these is
  `#append_environment_variable`. Using this variable appends a given value to
  an existing one. If the variable does not exist, it is created with the given
  value.

  Each variable name and each value is converted to a string. Otherwise `ruby`
  would complain about an invalid argument. To make use of a variable you can
  either use `#run` and the like or `#with_environment`.

  Background:
    Given I use the fixture "cli-app"

  Scenario: Non-existing variable
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { append_environment_variable 'LONG_LONG_VARIABLE', 'a' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=a' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Existing inner variable
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { append_environment_variable 'LONG_LONG_VARIABLE', 'a' }
      before(:each) { append_environment_variable 'LONG_LONG_VARIABLE', 'b' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'LONG_LONG_VARIABLE=ab' }
    end
    """
    When I run `rspec`
    Then the specs should all pass


  Scenario: Existing outer variable
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    ENV['REALLY_LONG_LONG_VARIABLE'] = 'a'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { append_environment_variable 'REALLY_LONG_LONG_VARIABLE', 'b' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it { expect(last_command_started.output).to include 'REALLY_LONG_LONG_VARIABLE=ab' }

      # Has no effect here, is not in block and not a command `run`
      it { expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq 'a' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Run some ruby code with previously set environment
    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    ENV['REALLY_LONG_LONG_VARIABLE'] = 'a'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { append_environment_variable 'REALLY_LONG_LONG_VARIABLE', 'b' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it do
        with_environment do
          expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq 'ab'
        end
      end

      # Has no effect here, is not in block and not a command `run`
      it { expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq 'a' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Run some ruby code with local environment

    If you pass the same variable to the block it will not be appended, but
    overwrites the variable

    Given a file named "spec/environment_spec.rb" with:
    """ruby
    require 'spec_helper'

    ENV['REALLY_LONG_LONG_VARIABLE'] = 'a'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { append_environment_variable 'REALLY_LONG_LONG_VARIABLE', 'b' }

      before(:each) { run_command('env') }
      before(:each) { stop_all_commands }

      it do
        with_environment 'REALLY_LONG_LONG_VARIABLE' => 'a' do
          expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq 'a'
        end
      end

      # Has no effect here, is not in block and not a command `run`
      it { expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq 'a' }
    end
    """
    When I run `rspec`
    Then the specs should all pass
