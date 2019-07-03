Feature: Check if command can be found in PATH

  If you need to check if a given command can be found in path, you can use the
  `be_a_command_found_in_path`-matcher.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Checking an existing executable file in PATH
    Given a file named "spec/existing_executable_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if command can be found in PATH', type: :aruba do
      let(:file) { 'my-exe' }

      before do
        touch(file)
        chmod(0o755, file)
        prepend_environment_variable('PATH', format('%s:', expand_path('.')))
      end

      it { expect(file).to be_a_command_found_in_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass
