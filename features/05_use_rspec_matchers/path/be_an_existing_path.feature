Feature: Check if path exists

  If you need to check if a given path exists, you can use the
  `be_an_existing_path`-matcher. It doesn't care if the path is a directory or
  a path.

  ```ruby
  require 'spec_helper'

  RSpec.describe 'Check if path exists', :type => :aruba do
    let(:path) { 'file.txt' }
    before(:each) { touch(path) }

    it { expect(path).to be_an_existing_path }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Expect single existing path
    Given a file named "spec/existing_path_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path exists', :type => :aruba do
      let(:path) { 'file.txt' }
      before(:each) { touch(path) }
      it { expect(path).to be_an_existing_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect single existing directory
    Given a file named "spec/existing_path_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path exists', :type => :aruba do
      let(:path) { 'dir.d' }
      before(:each) { create_directory(path) }
      it { expect(path).to be_an_existing_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect single non-existing path
    Given a file named "spec/existing_path_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path exists', :type => :aruba do
      let(:path) { 'file.txt' }
      it { expect(path).not_to be_an_existing_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect multiple existing paths
    Given a file named "spec/existing_path_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path exists', :type => :aruba do
      let(:paths) { %w(path1.txt path2.txt) }

      before :each do
        paths.each { |f| touch(f) }
      end

      it { expect(paths).to all be_an_existing_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect a least one existing path
    Given a file named "spec/existing_path_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path exists', :type => :aruba do
      let(:paths) { %w(path1.txt path2.txt) }

      before :each do
        touch(paths.first)
      end

      it { expect(paths).to include an_existing_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass

