Feature: Check if path has permissions in filesystem

  If you need to check if a given path has some permissions in filesystem, you
  can use the `have_permissions`-matcher. It fails if the file or directory
  does not exist. You need to pass it the permissions either as `Octal`
  (`0700`) or `String` (`'0700'`).

  ```ruby
  require 'spec_helper'

  RSpec.describe 'Check if path has permissions', :type => :aruba do
    context 'when is file' do
      let(:file) { 'file.txt' }
      let(:permissions) { 0700 }

      before(:each) { touch(file) }
      before(:each) { chmod(permissions, file }

      it { expect(file).to have_permissions permissions }
    end
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Expect file with permissions
    Given a file named "spec/path_with_permissions_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path has permissions', :type => :aruba do
      let(:file) { 'file.txt' }
      let(:permissions) { 0700 }

      before(:each) { touch(file) }
      before(:each) { chmod(permissions, file) }

      it { expect(file).to have_permissions permissions }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect directory with permissions
    Given a file named "spec/path_with_permissions_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path has permissions', :type => :aruba do
      let(:directory) { 'directory.d' }
      let(:permissions) { 0700 }

      before(:each) { create_directory(directory) }
      before(:each) { chmod(permissions, directory) }

      it { expect(directory).to have_permissions permissions }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect multiple files with given permissions
    Given a file named "spec/path_with_permissions_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path has permissions', :type => :aruba do
      let(:files) { %w(file1.txt file2.txt) }
      let(:permissions) { 0700 }

      before :each do
        files.each do |f|
          touch(f)
          chmod(permissions, f)
        end
      end

      it { expect(files).to all have_permissions permissions }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect a least one file with permissions
    Given a file named "spec/path_with_permissions_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path has permissions', :type => :aruba do
      let(:files) { %w(file1.txt file2.txt) }
      let(:permissions) { 0700 }

      before :each do
        touch(files.first)
        chmod(permissions, files.first)
      end

      it { expect(files).to include a_path_having_permissions permissions }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Fails if path does not exist
    Given a file named "spec/path_with_permissions_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path has permissions', :type => :aruba do
      let(:path) { 'file.txt' }
      let(:permissions) { 0777 }

      it { expect(path).to have_permissions permissions }
    end
    """
    When I run `rspec`
    Then the specs should not all pass
