Feature: Use fixtures in your tests

  Sometimes your tests need existing files to work - e.g binary data files you
  cannot create programmatically. All you need to do is the following:

  1. Create a `fixtures`-directory
  2. Create fixture files in this directory

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Use a fixture for your tests
    Given a file named "spec/fixture_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'My Feature', :type => :aruba do
      describe 'Copy file' do
        context 'when the file exists' do
          before :each { copy '%/song.mp3', 'file.mp3' }

          it { expect('file.mp3').to be_an_existing_file }
        end
      end
    end
    """
    And a directory named "fixtures"
    And an empty file named "fixtures/song.mp3"
    When I run `rspec`
    Then the specs should all pass

  Scenario: Pass file from fixtures to your command
    Given a file named "spec/fixture_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'My Feature', :type => :aruba do
      before :each { copy '%/my_file.txt', 'new_file.txt' }
      before :each { run_command 'aruba-test-cli new_file.txt' }

      it { expect(last_command_started).to have_output 'Hello Aruba!' }
    end
    """
    And a directory named "fixtures"
    And a file named "fixtures/my_file.txt" with:
    """
    Hello Aruba!
    """
    And a file named "bin/aruba-test-cli" with:
    """
    #!/usr/bin/env ruby

    puts File.read(ARGV[0]).chomp
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Use a fixture for your tests in test/
    Given a file named "features/fixtures.feature" with:
    """
    require 'spec_helper'

    RSpec.describe 'My Feature', :type => :aruba do
      describe 'Copy file' do
        context 'when the file exists' do
          before :each { copy '%/song.mp3', 'file.mp3' }

          it { expect('file.mp3').to be_an_existing_file }
        end
      end
    end
    """
    And a directory named "test/fixtures"
    And an empty file named "test/fixtures/fixtures-app/test.txt"
    When I run `rspec`
    Then the specs should all pass

  Scenario: Use a fixture for your tests in spec/
    Given a file named "features/fixtures.feature" with:
    """
    require 'spec_helper'

    RSpec.describe 'My Feature', :type => :aruba do
      describe 'Copy file' do
        context 'when the file exists' do
          before :each { copy '%/song.mp3', 'file.mp3' }

          it { expect('file.mp3').to be_an_existing_file }
        end
      end
    end
    """
    And a directory named "spec/fixtures"
    And an empty file named "spec/fixtures/fixtures-app/test.txt"
    When I run `rspec`
    Then the specs should all pass

  Scenario: Use a fixture for your tests in features/
    Given a file named "features/fixtures.feature" with:
    """
    require 'spec_helper'

    RSpec.describe 'My Feature', :type => :aruba do
      describe 'Copy file' do
        context 'when the file exists' do
          before :each { copy '%/song.mp3', 'file.mp3' }

          it { expect('file.mp3').to be_an_existing_file }
        end
      end
    end
    """
    And a directory named "features/fixtures"
    And an empty file named "features/fixtures/fixtures-app/test.txt"
    When I run `rspec`
    Then the specs should all pass
