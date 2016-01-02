Feature: Check if path exists and is an executable file

  If you need to check if a given path exists and is a file, you can use the
  `be_an_existing_executable`-matcher.

  ```ruby
  require 'spec_helper'

  RSpec.describe 'Check if file exists and is an executable file', :type => :aruba do
    let(:file) { 'file.txt' }
    before(:each) { touch(file) }
    before(:each) { chmod(0755, file) }

    it { expect(file).to be_an_existing_executable }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Expect single existing executable file
    Given a file named "spec/existing_executable_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file exists and is an executable file', :type => :aruba do
      let(:file) { 'file.txt' }
      before(:each) { touch(file) }
      before(:each) { chmod(0755, file) }

      it { expect(file).to be_an_existing_executable }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect single non-existing executable file
    Given a file named "spec/existing_executable_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file exists and is an executable file', :type => :aruba do
      let(:file) { 'file.txt' }
      it { expect(file).not_to be_an_existing_executable }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect multiple existing executable files
    Given a file named "spec/existing_executable_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file exists and is an executable file', :type => :aruba do
      let(:files) { %w(file1.txt file2.txt) }

      before :each do
        files.each do |f|
          touch(f)
          chmod(0755, f)
        end
      end

      it { expect(files).to all be_an_existing_executable }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect a least one existing executable file
    Given a file named "spec/existing_executable_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file exists and is an executable file', :type => :aruba do
      let(:files) { %w(file1.txt file2.txt) }

      before :each do
        touch(files.first)
        chmod(0755, files.first)
      end

      it { expect(files).to include an_existing_executable }
    end
    """
    When I run `rspec`
    Then the specs should all pass
