Feature: Check if path is absolute

  If you need to check if a given path is absolute , you can use the
  `be_an_absolute_path`-matcher. It doesn't care if the path is a directory or
  a path.

  ```ruby
  require 'spec_helper'

  RSpec.describe 'Check if path is absolute', :type => :aruba do
    let(:path) { 'file.txt' }
    before(:each) { touch(path) }

    it { expect(path).to be_an_absolute_path }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Expect single existing path
    Given a file named "spec/absolute_path_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path is absolute', :type => :aruba do
      let(:path) { '/path/to/file.txt' }
      it { expect(path).to be_an_absolute_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect multiple absolute paths
    Given a file named "spec/absolute_path_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path is absolute', :type => :aruba do
      let(:paths) { %w(/path/to/path1.txt /path/to/path2.txt) }

      it { expect(paths).to all be_an_absolute_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect a least one existing path
    Given a file named "spec/absolute_path_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path is absolute', :type => :aruba do
      let(:paths) { %w(/path/to/path1.txt path2.txt) }

      it { expect(paths).to include an_absolute_path }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Expect failure on relative path
    Given a file named "spec/absolute_path_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Check if path is absolute', :type => :aruba do
      let(:paths) { %w(path2.txt) }

      it { expect(paths).to be_an_absolute_path }
    end
    """
    When I run `rspec`
    Then the specs should not all pass
