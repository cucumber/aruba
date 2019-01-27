Feature: Supported Testing Frameworks

  You can use `aruba` with all major testing frameworks from the Ruby World:

    \* Cucumber
    \* RSpec
    \* Minitest

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Use "aruba" with "Cucumber"
    Given a file named "features/support/env.rb" with:
    """
    require 'aruba/cucumber'
    """
    And a file named "features/use_aruba_with_cucumber.feature" with:
    """
    Feature: Cucumber
      Scenario: First Run
        Given a file named "file.txt" with:
        \"\"\"
        Hello World
        \"\"\"
        Then the file "file.txt" should contain:
        \"\"\"
        Hello World
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Use "aruba" with "RSpec"
    Given a file named "spec/spec_helper.rb" with:
    """
    $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

    require 'aruba/rspec'
    """
    And a file named "spec/use_aruba_with_rspec_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'First Run', :type => :aruba do
      let(:file) { 'file.txt' }
      let(:content) { 'Hello World' }

      before(:each) { write_file file, content }

      it { expect(read(file)).to eq [content] }
    end
    """
    When I run `rspec`
    Then the specs should all pass


  Scenario: Use "aruba" with "Minitest"
    Given a file named "test/test_helper.rb" with:
    """
    $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

    require 'aruba/api'
    """
    And a file named "test/use_aruba_with_minitest.rb" with:
    """
    $LOAD_PATH.unshift File.expand_path('../test', __FILE__)

    require 'test_helper'
    require 'minitest/autorun'

    class FirstRun < Minitest::Test
      include Aruba::Api

      def setup
        aruba_setup
      end

      def getting_started_with_aruba
        file = 'file.txt'
        content = 'Hello World'

        write_file file, content
        read(file).must_equal [content]
      end
    end
    """
    When I run `ruby -Ilib:test test/use_aruba_with_minitest.rb`
    Then the tests should all pass
