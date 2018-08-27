Feature: Expand paths with aruba

  There are quite a few uses cases why you want to expand a path. `aruba` helps
  you with this by providing you the `expand_path`-method. This method expands
  paths relative to the `aruba.current_directory`-directory.

  Background:
    Given I use the fixture "cli-app"

  Scenario: Use relative path
    Given a file named "spec/expand_path_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Expand path', :type => :aruba do
      let(:path) { 'path/to/dir' }
      it { expect(expand_path(path)).to eq File.join(aruba.root_directory, aruba.current_directory, path) }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Change directory using cd
    Given a file named "spec/expand_path_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Expand path', :type => :aruba do
      let(:path) { 'path/to/dir' }
      let(:directory) { 'dir1' }

      before(:each) { create_directory(directory) }
      before(:each) { cd(directory) }

      it { expect(expand_path(path)).to eq File.join(aruba.root_directory, aruba.current_directory, path) }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Warn if aruba's working directory does not exist
    Given a file named "spec/expand_path_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Expand path', :type => :aruba do
      before(:each) { remove('.') }

      let(:path) { 'path/to/dir' }

      it { expect { expand_path(path) }.to output(/working directory does not exist/).to_stderr }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Use ~ in path

    Now this useses the HOME-variable from your normal shell HOME-variable.
    From 1.0.0 on HOME will be `File.join(aruba.config.root_directory,
    aruba.config.working_directory)`. If you want HOME have some other value,
    you need to configure it explicitly via `Aruba.configure {}`.

    Given a file named "spec/expand_path_spec.rb" with:
    """ruby
    require 'spec_helper'

    # Old before 1.0.0
    RSpec.describe 'Expand path', :type => :aruba do
      let(:path) { '~/path/to/dir' }

      it { expect(expand_path(path)).to match %r</home/[^/]+/path/to/dir> }
    end

    # New from 1.0.0
    RSpec.describe 'Expand path', :type => :aruba do
      let(:path) { '~/path/to/dir' }

      before(:each) do
        set_environment_variable('HOME', File.join(aruba.config.root_directory, aruba.config.working_directory))
      end

      it { expect(expand_path(path)).to eq File.join(aruba.config.root_directory, aruba.config.working_directory, 'path/to/dir') }
    end
    """
    When I run `rspec`
    Then the specs should all pass

