Feature: Check if file has content

  If you need to check if a given file has content, you can use the
  `have_file_content`-matcher. It accepts `Object`, `Regexp` or any other
  `RSpec::Matcher`-matchers. It fails if file does not exist.

  ```ruby
  require 'spec_helper'

  RSpec.describe 'Check if file has content', :type => :aruba do
    let(:file) { 'file.txt' }
    let(:content) { 'Hello World' }

    before(:each) { write_file(file, content) }

    it { expect(file).to have_file_content content }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Expect existing file with content
    Given a file named "spec/file_with_content_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check file content', :type => :aruba do
      let(:file) { 'file.txt' }
      let(:content) { 'Hello World' }

      before(:each) { write_file(file, content) }

      it { expect(file).to have_file_content content }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect existing file with partial content
    Given a file named "spec/file_with_content_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check file content', :type => :aruba do
      let(:file) { 'file.txt' }
      let(:content) { 'Hello World' }

      before(:each) { write_file(file, content) }

      it { expect(file).to have_file_content /Hello/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect existing file with partial content described by another matcher
    Given a file named "spec/file_with_content_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check file content', :type => :aruba do
      let(:file) { 'file.txt' }
      let(:content) { 'Hello World' }

      before(:each) { write_file(file, content) }

      it { expect(file).to have_file_content a_string_starting_with('Hello') }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect multiple existing files with content
    Given a file named "spec/file_with_content_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check file content', :type => :aruba do
      let(:files) { %w(file1.txt file2.txt) }
      let(:content) { 'Hello World' }

      before :each do
        files.each { |f| write_file(f, content) }
      end

      it { expect(files).to all have_file_content content }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect at least one file with content
    Given a file named "spec/file_with_content_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check file content', :type => :aruba do
      let(:files) { %w(file1.txt file2.txt) }
      let(:content) { 'Hello World' }

      before(:each) { write_file(files.first, content) }

      it { expect(files).to include a_file_having_content content }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Fails if file does not exist
    Given a file named "spec/file_with_content_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check file content', :type => :aruba do
      let(:file) { 'file.txt' }
      let(:content) { 'Hello World' }

      it { expect(file).to have_file_content content }
    end
    """
    When I run `rspec`
    Then the specs should not all pass
