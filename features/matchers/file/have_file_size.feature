Feature: Check if path has size

  If you need to check if a given path has file size, you can use the
  `have_file_size`-matcher. It fails if the file does not exist.

  ```ruby
  require 'spec_helper'

  RSpec.describe 'Check if file has size', :type => :aruba do
    let(:file) { 'file.txt' }
    let(:size) { 1 }

    before(:each) { write_fixed_size_file(file, size) }

    it { expect(file).to have_file_size size }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Expect file of given size
    Given a file named "spec/file_of_size_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file has size', :type => :aruba do
      let(:file) { 'file.txt' }
      let(:size) { 1 }

      before(:each) { write_fixed_size_file(file, size) }

      it { expect(file).to have_file_size size }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect multiple files of given size
    Given a file named "spec/file_of_size_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file has size', :type => :aruba do
      let(:files) { %w(file1.txt file2.txt) }
      let(:size) { 1 }

      before :each do
        files.each { |f| write_fixed_size_file(f, size) }
      end

      it { expect(files).to all have_file_size size }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect a least one file of size
    Given a file named "spec/file_of_size_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file has size', :type => :aruba do
      let(:files) { %w(file1.txt file2.txt) }
      let(:size) { 1 }

      before :each do
        write_fixed_size_file(files.first, size)
      end

      it { expect(files).to include a_file_of_size size }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Fails because file has different size than expected
    Given a file named "spec/file_of_size_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file has size', :type => :aruba do
      let(:file) { 'file.txt' }
      let(:size) { 1 }

      before(:each) { write_fixed_size_file(file, size) }

      it { expect(file).to have_file_size 2 }
    end
    """
    When I run `rspec`
    Then the specs should not all pass

  Scenario: Fails if file does not exist
    Given a file named "spec/file_of_size_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if file has size', :type => :aruba do
      let(:file) { 'file.txt' }
      let(:size) { 1 }

      it { expect(file).to have_file_size size }
    end
    """
    When I run `rspec`
    Then the specs should not all pass
