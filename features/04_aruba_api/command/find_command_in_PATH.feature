Feature: Get path to command

  Sometimes you only know a commands name, but not where to find it. Here comes
  `which` to the rescue.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Existing executable
    Given an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    exit 0
    """
    And a file named "spec/which_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Find path for command', :type => :aruba do
      it { expect(which('cli')).to match %r{tmp/aruba/cli-app/bin/cli} }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Non-existing executable
    Given a file named "bin/cli" does not exist
    And a file named "spec/which_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Find path for command', :type => :aruba do
      it { expect(which('cli')).to be_nil }
    end
    """
    When I run `rspec`
    Then the specs should all pass
