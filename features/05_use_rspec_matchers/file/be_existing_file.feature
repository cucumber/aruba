Feature: Check if path exists and is file

  If you need to check if a given path exists and is a file, you can use the
  `be_an_existing_file`-matcher.

  ```ruby
  require 'spec_helper'

  RSpec.describe 'Check if file exists and is file', :type => :aruba do
    let(:file) { 'file.txt' }
    before(:each) { touch(file) }

    it { expect(file).to be_an_existing_file }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Expect single existing file
    Given a file named "spec/existing_file_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file exists and is file', :type => :aruba do
      let(:file) { 'file.txt' }
      before(:each) { touch(file) }
      it { expect(file).to be_an_existing_file }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect single non-existing file
    Given a file named "spec/existing_file_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file exists and is file', :type => :aruba do
      let(:file) { 'file.txt' }
      it { expect(file).not_to be_an_existing_file }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect multiple existing files
    Given a file named "spec/existing_file_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file exists and is file', :type => :aruba do
      let(:files) { %w(file1.txt file2.txt) }

      before :each do
        files.each { |f| touch(f) }
      end

      it { expect(files).to all be_an_existing_file }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect a least one existing file
    Given a file named "spec/existing_file_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file exists and is file', :type => :aruba do
      let(:files) { %w(file1.txt file2.txt) }

      before :each do
        touch(files.first)
      end

      it { expect(files).to include an_existing_file }
    end
    """
    When I run `rspec`
    Then the specs should all pass

