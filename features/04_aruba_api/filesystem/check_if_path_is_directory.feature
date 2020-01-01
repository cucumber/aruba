Feature: Check existence of directories

  Use the `#directory?` to check if a path is a directory and exists within
  `aruba`'s working directory.

  ```ruby
  require 'spec_helper'

  RSpec.configure do |config|
    config.include Aruba::Api
  end

  RSpec.describe 'Check if directory and file exist' do
    let(:directory) { 'dir.d' }

    before(:each) { create_directory(directory) }

    it { expect(directory?(directory)).to be true }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Is directory and exist
    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Check if directory and file exist', :type => :aruba do
      let(:directory) { 'dir.d' }
      before(:each) { create_directory(directory) }

      it { expect(directory?(directory)).to be true }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Does not warn when passed an absolute path
    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Check that no warnings are printed when passed an absolute path', :type => :aruba do
      let(:directory) { 'dir.d' }
      let(:expanded_directory) { File.expand_path(directory) }

      before(:each) { create_directory(expanded_directory) }

      it { expect(directory?(expanded_directory)).to be true }
    end
    """
    When I run `rspec`
    Then the specs should all pass
    And the output should not contain:
    """
    Aruba's `expand_path` method was called with an absolute path
    """

  Scenario: Is file, but should be directory and exist
    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Check if directory and file exist', :type => :aruba do
      let(:file) { 'file.txt' }
      before(:each) { touch(file) }

      it { expect(directory?(file)).to be false }
    end
    """
    When I run `rspec`
    Then the specs should all pass
