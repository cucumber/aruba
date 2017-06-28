Feature: Create Directory

  Use the `#create_directory`-method to create a directory within `aruba`'s
  working directory.

  ```ruby
  require 'spec_helper'

  RSpec.configure do |config|
    config.include Aruba::Api
  end

  RSpec.describe 'Create directory' do
    let(:directory) { 'dir.d' }
    before(:each) { create_directory(directory) }

    it { expect(directory).to be_an_existing_directory }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: New directory
    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Create directory', :type => :aruba do
      let(:directory) { 'dir.d' }
      before(:each) { create_directory(directory) }

      it { expect(directory).to be_an_existing_directory }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Existing directory

    It does not complain if a directory already exists.

    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Create directory', :type => :aruba do
      let(:directory) { 'dir.d' }

      before(:each) { create_directory(directory) }
      before(:each) { create_directory(directory) }

      it { expect(directory).to be_an_existing_directory }
    end
    """
    When I run `rspec`
    Then the specs should all pass
