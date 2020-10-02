Feature: Check if path is absolute

  If you need to check if a given path is absolute , you can use the
  `be_an_absolute_path`-matcher. It doesn't care if the path is a directory or
  a file.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Checking an absolute path
    Given a file named "spec/absolute_path_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'an absolute path', :type => :aruba do
      let(:path) { '/path/to/file.txt' }

      it "is absolute" do
        expect(path).to be_an_absolute_path
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
