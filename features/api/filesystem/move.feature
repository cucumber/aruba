Feature: Move file/directory

  If you need to move some files/directories you can use the `#move`-method
  command. If multiple arguments are given, the last one needs to be a directory.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Non-existing destination
    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Move', :type => :aruba do
      let(:old_location) { 'old_dir.d' }
      let(:new_location) { 'new_dir.d' }

      before(:each) do 
        create_directory old_location
        move old_location, new_location
      end

      it { expect(new_location).to be_an_existing_directory }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Existing destination
    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Move', :type => :aruba do
      let(:old_location) { 'old_dir.d' }
      let(:new_location) { 'new_dir.d' }

      before(:each) do 
        create_directory old_location
        create_directory new_location

        move old_location, new_location
      end

      it { expect(File.join(new_location, old_location)).to be_an_existing_directory }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Source is fixture path
    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Move', :type => :aruba do
      let(:old_location) { '%/old_dir.d' }
      let(:new_location) { 'new_dir.d' }

      it { expect { move old_location, new_location }.to raise_error ArgumentError, /fixture/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Destination is fixture path
    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Move', :type => :aruba do
      let(:old_location) { 'old_dir.d' }
      let(:new_location) { '%/new_dir.d' }

      it { expect { move old_location, new_location }.to raise_error ArgumentError, /fixture/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Multiple sources and destination is directory
    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Move', :type => :aruba do
      let(:old_location) { %w(old_dir1.d old_dir2.d) }
      let(:new_location) { 'new_dir.d' }

      before :each do
        old_location.each { |l| create_directory l }
        move old_location, new_location
      end

      it { expect(old_location.map { |l| File.join(new_location, l) }).to all be_an_existing_directory }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Multiple sources and destination is file
    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Move', :type => :aruba do
      let(:old_location) { %w(old_dir1.d old_dir2.d) }
      let(:new_location) { 'new_file.txt' }

      before :each do
        old_location.each { |l| create_directory l }
        touch new_location
      end

      it { expect { move old_location, new_location }.to raise_error ArgumentError, /Multiple sources/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass
