Feature: Check existence of files

  Use the `#file?` to check if a path is a file and exists within `aruba`'s
  working directory.

  ```ruby
  require 'spec_helper'

  RSpec.configure do |config|
    config.include Aruba::Api
  end

  RSpec.describe 'Check if directory and file exist' do
    let(:file) { 'file.txt' }

    before(:each) { touch(file) }

    it { expect(file?(file)).to be true }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Is file and exist
    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Check if directory and file exist', :type => :aruba do
      let(:file) { 'file.txt' }

      before(:each) { touch(file) }

      it { expect(file?(file)).to be true }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Is directory, but should be file and exist
    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Check if directory and file exist', :type => :aruba do
      let(:directory) { 'dir.d' }
      before(:each) { create_directory(directory) }

      it { expect(file?(directory)).to be false }
    end
    """
    When I run `rspec`
    Then the specs should all pass
