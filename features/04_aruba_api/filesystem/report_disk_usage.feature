Feature: Report disk usage

  Sometimes you need to check, what amount of disk space a file consumes.

  This is useful, since many tiny files will usually take up a lot more disk
  space than their sizes suggest.

  While not be very accurate, `'#disk_usage` helps estimate this "real"
  allocated size on disk.

  NOTE 1: currently "directories" are NOT supported.

  NOTE 2: Aruba assumes the 'physical block size' is 512 bytes. (It usually is).

  If your OS/filesystem doesn't report the number of blocks used (and your
  allocation unit size is not 4096 bytes), you can change the default "block
  size" Aruba uses for calculations:

  E.g. for a 32kB "allocation unit size" and 16 blocks used for a tiny file
  (check `File::Stat.blocks` reported by Ruby), just divide the
  two numbers to get the "physical block size" you need to set:

  `Aruba.configure { |config| config.physical_block_size = 32_768 / 16 }`.


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

      before do 
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

      before do 
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

      before do 
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

      before do 
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

      before do 
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

      before do 
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
