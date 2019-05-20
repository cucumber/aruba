Feature: Getting started with RSpec and aruba

  Background:
    Given I use the fixture "empty-app"

  Scenario: Simple Integration

    To use the simple integration just require `aruba/rspec` in your
    `spec_helper.rb`. After that you only need to flag your tests with `type:
    :aruba` and some things are set up for.

    The simple integration adds some `before(:each)` hooks for you:

      \* Setup Aruba Test directory
      \* Clear environment (ENV)
      \* Make HOME variable configurable via `arub.config.home_directory`
      \* Configure `aruba` via `RSpec` metadata
      \* Activate announcers based on `RSpec` metadata

    Be careful, if you are going to use a `before(:all)` hook to set up
    files/directories. Those will be deleted by the `setup_aruba` call within
    the `before(:each)` hook. Look for some custom integration further down the
    documentation for a solution.

    Given a file named "spec/spec_helper.rb" with:
    """
    require 'aruba/rspec'
    """
    And a file named "spec/getting_started_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Integrate Aruba into RSpec', :type => :aruba do
      context 'when to be or not be...' do
        it { expect(aruba).to be }
      end

      context 'when write file' do
        let(:file) { 'file.txt' }

        before(:each) { write_file file, 'Hello World' }

        it { expect(file).to be_an_existing_file }
        it { expect([file]).to include an_existing_file }
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Simple Custom Integration

    There might be some use cases where you want to build an aruba integration
    of your own. You need to include the API and make sure, that you run

      \* `restore_env` (only for aruba < 1.0.0)
      \* `setup_aruba`

    before any method of aruba is used.

    Given a file named "spec/spec_helper.rb" with:
    """
    require 'aruba/api'

    RSpec.configure do |config|
      config.include Aruba::Api
    end
    """
    And a file named "spec/getting_started_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Custom Integration of aruba' do
      let(:file) { 'file.txt' }

      before(:each) { setup_aruba }
      before(:each) { write_file file, 'Hello World' }

      it { expect(file).to be_an_existing_file }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Custom Integration using before(:all) hook

    You can even use `aruba` within a `before(:all)` hook. But again, make sure
    that `setup_aruba` is run before you use any method of `aruba`. Using
    `setup_aruba` both in a `before(:all)` and a `before(:each)` hook is not
    possible and therefore not supported:

    Running `setup_aruba` removes `tmp/aruba`, creates a new `tmp/aruba`, and
    makes that the working directory. Running it within a `before(:all)` hook,
    running some `aruba` method and, then running `setup_aruba` again within a
    `before(:each)` hook, will remove the files and directories created within
    the `before(:all)` hook.

    Given a file named "spec/spec_helper.rb" with:
    """
    require 'aruba/api'

    RSpec.configure do |config|
      config.include Aruba::Api
    end
    """
    And a file named "spec/getting_started_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Custom Integration of aruba' do
      before(:all) { setup_aruba }
      before(:all) { write_file 'file.txt', 'Hello World' }

      it { expect('file.txt').to be_an_existing_file }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Setup aruba before use any of it's methods

    From 1.0.0 it will be required, that you setup aruba before you use it.

    Given a file named "spec/spec_helper.rb" with:
    """
    require 'aruba/api'

    RSpec.configure do |config|
      config.include Aruba::Api
    end
    """
    And a file named "spec/getting_started_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Custom Integration of aruba' do
      let(:file) { 'file.txt' }

      before(:each) { setup_aruba }

      it { expect(true).to be true }
    end
    """
    And an empty file named "tmp/aruba/garbage.txt"
    When I run `rspec`
    Then the specs should all pass
    And the file "tmp/aruba/garbage.txt" should not exist anymore

  Scenario: Fail-safe use if "setup_aruba" is not used

    If you forgot to run `setup_aruba` before the first method of aruba is
    used, you might see an error. Although we did our best to prevent this.

    Make sure that you run `setup_aruba` before any method of aruba is used. At
    best before each and every test.

    This will be not supported anymore from 1.0.0 on.

    Given a file named "spec/spec_helper.rb" with:
    """
    require 'aruba/api'

    RSpec.configure do |config|
      config.include Aruba::Api
    end
    """
    And a file named "spec/getting_started_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Custom Integration of aruba' do
      let(:file) { 'file.txt' }

      it { expect { write_file file, 'Hello World' }.not_to raise_error }
      it { expect(aruba.current_directory.directory?).to be true }
    end
    """
    When I run `rspec`
    Then the specs should all pass
