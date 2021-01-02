Feature: Expand paths with aruba

  There are quite a few uses cases why you want to expand a path. Aruba helps
  you with this by providing you the `expand_path`-method. This method expands
  paths relative to the `aruba.current_directory`-directory.

  Use of absolute paths is discouraged, since the intent is to only access the
  isolated Aruba working directory.

  Background:
    Given I use the fixture "cli-app"

  Scenario: Using a relative path
    Given a file named "spec/expand_path_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Expand path', :type => :aruba do
      let(:path) { 'path/to/dir' }

      it "expands relative to Aruba's home directory" do
        expected_path = File.join(aruba.config.home_directory, path)

        expect(expand_path(path)).to eq expected_path
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Using a relative path after changing directory using cd
    Given a file named "spec/expand_path_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Expand path', :type => :aruba do
      let(:path) { 'path/to/dir' }
      let(:directory) { 'dir1' }

      before do
        create_directory directory
      end

      it "expands relative to the new directory" do
        cd directory
        expected_path = File.join(aruba.config.home_directory, directory, path)

        expect(expand_path(path)).to eq expected_path
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Warn when using absolute path
    Given a file named "spec/expand_path_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Expand path', :type => :aruba do
      let(:path) { '/path/to/dir' }
      it { expect(expand_path(path)).to eq path }
    end
    """
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    Aruba's `expand_path` method was called with an absolute path
    """

  Scenario: Silence warning about using absolute path

    You can use config.allow_absolute_paths to silence the warning about the
    use of absolute paths.

    Given a file named "spec/expand_path_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Expand path', :type => :aruba do
      let(:path) { '/path/to/dir' }
      before { aruba.config.allow_absolute_paths = true }
      it { expect(expand_path(path)).to eq path }
    end
    """
    When I run `rspec`
    Then the specs should all pass
    And the output should not contain:
    """
    Aruba's `expand_path` method was called with an absolute path
    """

  Scenario: Raise an error if aruba's working directory does not exist
    Given a file named "spec/expand_path_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Expand path', :type => :aruba do
      before { remove('.') }

      let(:path) { 'path/to/dir' }

      it { expect { expand_path(path) }.to raise_error(/working directory does not exist/) }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Use ~ in path

    Aruba sets HOME to `File.join(aruba.config.root_directory,
    aruba.config.working_directory)`. If you want HOME have some other value,
    you need to configure it explicitly via `Aruba.configure {}`.

    Given a file named "spec/expand_path_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Expand path', :type => :aruba do
      let(:path) { '~/path/to/dir' }
      let(:directory) { 'dir1' }

      before do
        create_directory(directory)
        cd directory
      end

      it { expect(expand_path(path)).to eq File.join(aruba.config.home_directory, 'path/to/dir') }
    end
    """
    When I run `rspec`
    Then the specs should all pass
