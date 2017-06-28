Feature: Check if path is absolute

  Use the `#absolute?`-method to check if a path is an absolute path.

  ```ruby
  require 'spec_helper'

  RSpec.configure do |config|
    config.include Aruba::Api
  end

  RSpec.describe 'Check if directory or file is absolute' do
    let(:path) { '/path/to/file.txt' }

    it { expect(absolute?(path)).to be true }
  end
  ```

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Is path absolute
    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Check if directory or file is absolute', :type => :aruba do
      let(:path) { '/path/to/file.txt' }

      it { expect(absolute?(path)).to be true }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Path should be absolute, but it's relative
    Given a file named "spec/create_directory_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Check if directory or file is absolute', :type => :aruba do
      let(:path) { 'file.txt' }

      it { expect(absolute?(path)).to be false }
    end
    """
    When I run `rspec`
    Then the specs should all pass
