@unsupported-on-ruby-older-19
Feature: Report disk usage

  Sometimes you need to check, what amount of disk space a file consumes. We do
  NOT support "directories" with `#disk_usage`. This does not work reliably
  over different systems. Here can help `'#disk_usage`. But be careful, by
  default it uses a block size of "512" (physical block size) to calculate the
  usage. You may need to adjust this by using `Aruba.configure { |config|
  config.physical_block_size = 4_096 }`. Don't get confused, if you check the
  block size by using `File::Stat` (in ruby). It reports the block size of your
  filesystem, which can be "4_096" for example.

  We're gonna use the (correct) IEC-notation
  (https://en.wikipedia.org/wiki/Binary_prefix) here:

    \* kilo => kibi
    \* mega => mebi
    \* giga => gibi

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Show disk usage for file
    Given a file named "spec/disk_usage_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'disk usage', :type => :aruba do
      let(:file) { 'file.txt' }

      before(:each) do 
        write_file file, 'a'
      end

      let(:size_of_single_block) { File::Stat.new(expand_path(file)).blksize }

      it { expect(disk_usage(file)).to eq size_of_single_block }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Show disk usage for multiple files

    `#disk_usage` creates the sum of all given objects' sizes.

    Given a file named "spec/disk_usage_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'disk usage', :type => :aruba do
      let(:file1) { 'file1.txt' }
      let(:file2) { 'file2.txt' }

      before(:each) do 
        write_file file1, 'a'
        write_file file2, 'a'
      end

      let(:size_of_single_block) { File::Stat.new(expand_path(file1)).blksize }

      it { expect(disk_usage(file1, file2)).to eq size_of_single_block * 2 }
      it { expect(disk_usage([file1, file2])).to eq size_of_single_block * 2 }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Convert reported disk usage to KibiByte
    Given a file named "spec/disk_usage_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'disk usage', :type => :aruba do
      let(:file) { 'file.txt' }

      before(:each) do 
        write_file file, 'a'
      end

      let(:converted_size) { File::Stat.new(expand_path(file)).blksize.to_f / 1_024 }

      it { expect(disk_usage(file).to_kibi_byte).to eq converted_size }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Convert reported disk usage to MebiByte
    Given a file named "spec/disk_usage_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'disk usage', :type => :aruba do
      let(:file) { 'file.txt' }

      before(:each) do 
        write_file file, 'a'
      end

      let(:converted_size) { File::Stat.new(expand_path(file)).blksize.to_f / 1_024 / 1024 }

      it { expect(disk_usage(file).to_mebi_byte).to eq converted_size }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Convert reported disk usage to GibiByte
    Given a file named "spec/disk_usage_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'disk usage', :type => :aruba do
      let(:file) { 'file.txt' }

      before(:each) do 
        write_file file, 'a'
      end

      let(:converted_size) { File::Stat.new(expand_path(file)).blksize.to_f / 1_024 / 1_024 / 1_024 }

      it { expect(disk_usage(file).to_gibi_byte).to eq converted_size }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Compare two repored disk usages
    Given a file named "spec/disk_usage_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'disk usage', :type => :aruba do
      let(:file1) { 'file1.txt' }
      let(:file2) { 'file2.txt' }

      before(:each) do 
        write_file file1, 'a' * 10_000
        write_file file2, 'a'
      end

      before :each do
        @size1 = disk_usage(file1)
        @size2 = disk_usage(file2)
      end

      it { expect(@size1).to be > @size2 }
    end
    """
    When I run `rspec`
    Then the specs should all pass
