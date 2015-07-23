Feature: Check existence of files and directories

  Use the `#exist?` to check if a path exists within
  `aruba`'s working directory. , May also want to look for `#file?` or
  `#directory?` for some more specific tests.

  ```ruby
  require 'spec_helper'

  RSpec.configure do |config|
    config.include Aruba::Api
  end

  RSpec.describe 'Check if directory and file exist' do
    let(:directory) { 'dir.d' }
    let(:file) { 'file.txt' }

    before(:each) { create_directory(directory) }
    before(:each) { touch(file) }

    it { expect(exist?(directory)).to be true }
    it { expect(exist?(file)).to be true }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Is file or directory and exists
    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Check if directory and file exist', :type => :aruba do
      let(:directory) { 'dir.d' }
      let(:file) { 'file.txt' }

      before(:each) { create_directory(directory) }
      before(:each) { touch(file) }

      it { expect(exist?(directory)).to be true }
      it { expect(exist?(file)).to be true }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Is file or directory and does not exist
    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Check if directory and file exist', :type => :aruba do
      let(:directory) { 'dir.d' }
      let(:file) { 'file.txt' }

      it { expect(exist?(directory)).to be false }
      it { expect(exist?(file)).to be false }
    end
    """
    When I run `rspec`
    Then the specs should all pass
