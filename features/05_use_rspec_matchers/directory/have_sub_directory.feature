Feature: Check if directory has given sub directories

  If you need to check if a given directory has given sub dirctories, you can
  use the `have_sub_directory`-matcher.

  ```ruby
  require 'spec_helper'

  RSpec.describe 'Check if directory has sub-directory', :type => :aruba do
    let(:file) { 'file.txt' }
    before(:each) { touch(file) }

    it { expect(file).to be_an_existing_file }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Expect existing sub directory
    Given a file named "spec/existing_file_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if directory has sub-directory', :type => :aruba do
      let(:directory) { 'dir.d' }
      let(:sub_directory) { 'sub-dir.d' }

      before(:each) { create_directory(File.join(directory, sub_directory)) }

      it { expect(directory).to have_sub_directory sub_directory }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect multiple existing sub directories
    Given a file named "spec/existing_file_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if directory has sub-directory', :type => :aruba do
      let(:directory) { 'dir.d' }
      let(:sub_directories) { %w(sub-dir1.d sub-dir2.d) }

      before(:each) do
        sub_directories.each { |d| create_directory(File.join(directory, d)) }
      end

      it { expect(directory).to have_sub_directory sub_directories }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect non-existing sub directory
    Given a file named "spec/existing_file_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if directory has sub-directory', :type => :aruba do
      let(:directory) { 'dir.d' }
      let(:sub_directory) { 'sub-dir.d' }

      before(:each) { create_directory(directory) }

      it { expect(directory).not_to have_sub_directory sub_directory }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect multiple directories have sub directory
    Given a file named "spec/existing_file_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if directory has sub-directory', :type => :aruba do
      let(:directories) { %w(dir1.d dir2.d) }
      let(:sub_directory) { 'sub-dir.d' }

      before(:each) do
        directories.each { |d| create_directory(File.join(d, sub_directory)) }
      end

      it { expect(directories).to all have_sub_directory sub_directory }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect a least one directory has sub directory
    Given a file named "spec/existing_file_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if directory has sub-directory', :type => :aruba do
      let(:directories) { %w(dir1.d dir2.d) }
      let(:sub_directory) { 'sub-dir.d' }

      before(:each) do
        create_directory(File.join(directories.first, sub_directory))
      end

      it { expect(directories).to include a_directory_having_sub_directory sub_directory }
    end
    """
    When I run `rspec`
    Then the specs should all pass

