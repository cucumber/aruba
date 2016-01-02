Feature: Check if command can be found in PATH

  If you need to check if a given command can be found in path, you can use the
  `be_an_existing_executable`-matcher.

  ```ruby
  require 'spec_helper'

  RSpec.describe 'Check if command can be found in PATH', :type => :aruba do
    let(:file) { 'file.sh' }
    before(:each) { touch(file) }
    before(:each) { chmod(0755, file) }
    before(:each) { prepend_environment_variable('PATH', format('%s:', expand_path('.')) }

    it { expect(file).to be_an_existing_executable }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Expect single existing executable file
    Given a file named "spec/existing_executable_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if command can be found in PATH', :type => :aruba do
      let(:file) { 'file.sh' }

      before(:each) { touch(file) }
      before(:each) { chmod(0755, file) }
      before(:each) { prepend_environment_variable('PATH', format('%s:', expand_path('.'))) }

      it { expect(file).to be_a_command_found_in_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect single non-existing executable file
    Given a file named "spec/existing_executable_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if command can be found in PATH', :type => :aruba do
      let(:file) { 'file.sh' }

      before(:each) { prepend_environment_variable('PATH', format('%s:', expand_path('.'))) }

      it { expect(file).not_to be_a_command_found_in_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect single non-executable file
    Given a file named "spec/existing_executable_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if command can be found in PATH', :type => :aruba do
      let(:file) { 'file.sh' }

      before(:each) { touch(file) }
      before(:each) { prepend_environment_variable('PATH', format('%s:', expand_path('.'))) }

      it { expect(file).not_to be_a_command_found_in_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect multiple existing executable files
    Given a file named "spec/existing_executable_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file exists and is an executable file', :type => :aruba do
      let(:files) { %w(file1.sh file2.sh) }

      before :each do
        files.each do |f|
          touch(f)
          chmod(0755, f)
        end
      end

      before(:each) { prepend_environment_variable('PATH', format('%s:', expand_path('.'))) }

      it { expect(files).to all be_a_command_found_in_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect a least one existing executable file
    Given a file named "spec/existing_executable_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file exists and is an executable file', :type => :aruba do
      let(:files) { %w(file1.sh file2.sh) }

      before :each do
        touch(files.first)
        chmod(0755, files.first)
      end

      before(:each) { prepend_environment_variable('PATH', format('%s:', expand_path('.'))) }

      it { expect(files).to include a_command_found_in_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass
