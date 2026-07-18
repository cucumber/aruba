Feature: Configure the home directory to be used with aruba

  As a developer
  I want to use the home directory
  In order to use it elsewhere

  Background:
    Given I use the fixture "cli-app"

  Scenario: Default value
    Given a file named "spec/home_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'home_directory', :type => :aruba do
      it "is available on the Aruba runtime" do
        puts %(The home directory is "#{aruba.home_directory}")
      end
    end
    """
    When I successfully run `rspec`
    Then the output should match:
    """
    The home directory is "/.*/tmp/aruba"
    """
