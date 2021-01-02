Feature: Check if path is absolute

  Use the `#absolute?`-method to check if a path is an absolute path.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Is path absolute
    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'the absolute? method', :type => :aruba do
      let(:path) { '/path/to/file.txt' }

      it "returns true for an absolute path" do
        expect(absolute?(path)).to be true
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Path should be absolute, but it's relative
    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Check if directory or file is absolute', :type => :aruba do
      let(:path) { 'file.txt' }

      it { expect(absolute?(path)).to be false }
    end
    """
    When I run `rspec`
    Then the specs should all pass
