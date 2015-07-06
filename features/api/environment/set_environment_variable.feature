Feature: Set environment variable via API-method

  It is quite handy to modify the environment of a process. To make this
  possible, `aruba` provides several methods. One of these is
  `#set_environment_variable`. Using this variable sets the value of a
  non-existing variable and overwrites an existing value. Each variable name
  and each value is converted to a string. Otherwise `ruby` would complain
  about an invalid argument. To make use of a variable you can either use `#run`
  and the like or `#with_environment`. Besides setting a variable globally, you
  can set one for a block of code only using `#with_environment`.

  Background:
    Given I use the fixture "cli-app"

  Scenario: Non-existing variable
    Given a file named "spec/environment_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { set_environment_variable 'LONG_LONG_VARIABLE', '1' }
      before(:each) { run('env') }

      it { expect(last_command.output).to include 'LONG_LONG_VARIABLE=1' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Existing inner variable
    Given a file named "spec/environment_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { set_environment_variable 'LONG_LONG_VARIABLE', '1' }
      before(:each) { set_environment_variable 'LONG_LONG_VARIABLE', '2' }
      before(:each) { run('env') }

      it { expect(last_command.output).to include 'LONG_LONG_VARIABLE=2' }
    end
    """
    When I run `rspec`
    Then the specs should all pass


  Scenario: Existing outer variable
    Given a file named "spec/environment_spec.rb" with:
    """
    require 'spec_helper'

    ENV['REALLY_LONG_LONG_VARIABLE'] = '1'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '2' }
      before(:each) { run('env') }

      it { expect(last_command.output).to include 'REALLY_LONG_LONG_VARIABLE=2' }
      it { expect(ENV['REALLY_LONG_LONG_VARIABLE']).to eq '1' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Run some ruby code with previously set environment
    Given a file named "spec/environment_spec.rb" with:
    """
    require 'spec_helper'

    ENV['REALLY_LONG_LONG_VARIABLE'] = '1'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '2' }
      before(:each) { run('env') }

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
    Given a file named "spec/environment_spec.rb" with:
    """
    require 'spec_helper'

    ENV['REALLY_LONG_LONG_VARIABLE'] = '1'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '2' }
      before(:each) { run('env') }

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
    Given a file named "spec/environment_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { set_environment_variable 'LONG_LONG_VARIABLE', '1' }

      describe 'Method XX' do
        before(:each) { run('env') }

        it { expect(last_command.output).to include 'LONG_LONG_VARIABLE=1' }
      end

      describe 'Method YY' do
        before(:each) { set_environment_variable 'LONG_LONG_VARIABLE', '2' }
        before(:each) { run('env') }

        it { expect(last_command.output).to include 'LONG_LONG_VARIABLE=2' }
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: When an error occures the ENV is not polluted
    Given a file named "spec/environment_spec.rb" with:
    """
    require 'spec_helper'

    ENV['REALLY_LONG_LONG_VARIABLE'] = '1'

    RSpec.describe 'Long running command', :type => :aruba do
      before(:each) { set_environment_variable 'REALLY_LONG_LONG_VARIABLE', '2' }
      before(:each) { run('env') }

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
