Feature: Check if path exists and is an executable file

  If you need to check if a given path exists and is a file, you can use the
  `be_an_existing_executable`-matcher.

  Background:
    Given I use a fixture named "cli-app"

  @unsupported-on-platform-windows
  Scenario: Checking an executable file by permissions on Unix
    Given a file named "spec/existing_executable_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file exists and is an executable file', type: :aruba do
      let(:file) { 'my-exe' }

      before do
        touch(file)
        chmod(0o755, file)
      end

      it { expect(file).to be_an_existing_executable }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  @unsupported-on-platform-unix
  Scenario: Checking an executable file by file name on Windows
    Given a file named "spec/existing_executable_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file exists and is an executable file', type: :aruba do
      let(:file) { 'foo.bat' }

      before do
        touch(file)
        chmod(0o755, file)
      end

      it { expect(file).to be_an_existing_executable }
    end
    """
    When I run `rspec`
    Then the specs should all pass
