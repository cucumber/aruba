Feature: Isolated Aruba Working Directory

  Aruba creates an isolated scratch directory for every scenario.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Scenario does not see artifacts and pwd from previous scenario
    Given a file named "features/cleanup.feature" with:
    """
    Feature: Check
      Scenario: Check #1
        Given a file named "file.txt" with "content"
        And a directory named "dir.d"
        Then a file named "file.txt" should exist
        And a directory named "dir.d" should exist
        When I cd to "dir.d"
        And I run `pwd`
        Then the output should match %r</tmp/aruba-[^/]+/dir.d$>

      Scenario: Check #2
        Then a file named "file.txt" should not exist
        And a directory named "dir.d" should not exist
        When I run `pwd`
        Then the output should match %r</tmp/aruba-[^/]+$>
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Spec does not see artifacts and pwd from previous spec
    Given a file named "spec/cleanup_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'check', type: :aruba do
      specify 'number 1' do
        write_file('file.txt', 'content')
        create_directory('dir.d')
        expect('file.txt').to be_an_existing_file
        expect('dir.d').to be_an_existing_directory
        cd 'dir.d'
        run_command_and_stop('pwd')
        expect(last_command_started).to have_output %r</tmp/aruba-[^/]+/dir.d$>
      end

      specify 'number 2' do
        expect('file.txt').not_to be_an_existing_file
        expect('dir.d').not_to be_an_existing_directory
        run_command_and_stop('pwd')
        expect(last_command_started).to have_output %r</tmp/aruba-[^/]+$>
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Failing scenario leaves working directory behind for inspection
    Given a file named "features/failure.feature" with:
    """
    Feature: Check
      Scenario: Check #1
        Given a file named "file.txt" with "content"
        Then a file named "file.txt" should not exist
    """
    When I run `cucumber`
    Then the feature should fail
    And a directory matching %r</tmp/aruba-[^/]+$> should exist
    And a file matching %r</tmp/aruba-[^/]+/file.txt$> should exist
    And the output should match:
    """
    Find the Aruba working directory for inspection at .*/tmp/aruba-[^/]+
    """

  Scenario: Failing spec leaves working directory behind for inspection
    Given a file named "spec/failure_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'check', type: :aruba do
      specify 'number 1' do
        write_file('file.txt', 'content')
        expect('file.txt').not_to be_an_existing_file
      end
    end
    """
    When I run `rspec`
    Then the spec should fail
    And a directory matching %r</tmp/aruba-[^/]+$> should exist
    And a file matching %r</tmp/aruba-[^/]+/file.txt$> should exist
    And the output should match:
    """
    Find the Aruba working directory for inspection at .*/tmp/aruba-[^/]+
    """
