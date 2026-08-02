Feature: Configure working directory of aruba

  As a developer
  I want to configure the working directory of aruba
  In order to have a test directory for each used spec runner - e.g. cucumber or rspec

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "spec/support/aruba_config.rb" with:
    """ruby
    Aruba.configure do |config|
      puts %(The working directory suffix is "#{config.working_directory_suffix}")
    end
    """
    And a file named "spec/working_directory_configuration_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Workspace', :type => :aruba do
      it 'uses "aruba" by default' do
        run_command("pwd")
        expect(last_command_started).to have_output(/tmp\/aruba-[^\/]+$/)
      end
    end
    """
    When I successfully run `rspec`
    Then the output should contain:
    """
    The working directory suffix is "aruba"
    """

  Scenario: Modify value
    Given a file named "spec/support/aruba_config.rb" with:
    """
    Aruba.configure do |config|
      config.working_directory_suffix = 'cucumber'
    end
    """
    And a file named "spec/working_directory_configuration_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Workspace', :type => :aruba do
      it 'uses the configured suffix' do
        run_command("pwd")
        expect(last_command_started).to have_output(/tmp\/cucumber-[^\/]+$/)
        puts last_command_started.output
      end
    end
    """
    When I successfully run `rspec`
    Then the output should match %r<tmp/cucumber-[^\/]+$>
