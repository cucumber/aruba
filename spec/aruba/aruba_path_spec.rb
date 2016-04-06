require 'spec_helper'
require 'aruba/aruba_path'

RSpec.describe Aruba::ArubaPath do
  subject(:path) { described_class.new(new_path) }

  let(:new_path) { 'path/to/dir' }

  it { expect(path).to be }

  describe '#to_s' do
  end

  describe '#to_s' do
    context 'when string is used' do
      it { expect(path.to_s).to eq new_path }
    end

    # make it compatible with the old API
    context 'when array is used' do
      let(:net_path) { %w(path to dir) }

      it { expect(path.to_s).to eq File.join(*new_path) }
    end
  end

  describe '#push' do
    before(:each) { path.push 'subdir' }

    it { expect(path.to_s).to eq 'path/to/dir/subdir' }
  end

  describe '#<<' do
    before(:each) { path << 'subdir' }

    it { expect(path.to_s).to eq 'path/to/dir/subdir' }
  end

  describe '#pop' do
    before(:each) { path << 'subdir' }
    before(:each) { path.pop }

    it { expect(path.to_s).to eq 'path/to/dir' }
  end

  describe '#relative?' do
    context 'when is relative' do
      it { expect(path).to be_relative }
    end

    context 'when is absolute' do
      let(:new_path) { '/absolute/path' }
      it { expect(path).not_to be_relative }
    end
  end

  describe '#[]' do
    context 'when single index' do
      it { expect(path[0]).to eq 'p' }
    end

    context 'when range' do
      it { expect(path[0..1]).to eq 'pa' }
    end
  end

  describe '#depth' do
    context 'when relative path' do
      it { expect(path.depth).to eq 3 }
    end

    context 'when absolute path' do
      let(:new_path) { '/path/to/dir' }
      it { expect(path.depth).to eq 3 }
    end
  end

  describe '#end_with?' do
    it { expect(path).to be_end_with 'dir' }
  end

  describe '#start_with?' do
    it { expect(path).to be_start_with 'path/to' }
  end

  describe '#relative?' do
    it { expect(path).to be_relative }
  end

  describe '#absolute?' do
    let(:new_path) { '/path/to/dir' }
    it { expect(path).to be_absolute }
  end

  describe '#blocks' do
    let(:new_path) { expand_path('path/to/file') }
    let(:stat) { instance_double(File::Stat) }

    subject do
      path.blocks
    end

    before do
      allow(File::Stat).to receive(:new).and_return(stat)
      allow(stat).to receive(:blocks).and_return(blocks)
      allow(stat).to receive(:size) { size }
    end

    context "when blocks info is available" do
      let(:blocks) { 8 }
      it { is_expected.to eq 8 }
    end

    context "when blocks info is not available" do
      let(:blocks) { nil }

      context "when blksize is 512" do
        before do
          allow(Aruba.config).to receive(:physical_block_size).and_return(512)
        end

        context "when file is empty" do
          let(:size) { 0 }
          it { is_expected.to eq 8 } # on 4k block neede
        end

        context "when file is tiny" do
          let(:size) { 1 }
          it { is_expected.to eq 8 } # 8 * 512 = one 4k block
        end

        context "when the file would barely fit in a unit" do
          let(:size) { 4096 }
          it { is_expected.to eq 8 }
        end

        context "when the file wouldn't fit in a 4k unit" do
          let(:size) { 4096 + 1 }
          it { is_expected.to eq 16 }
        end

        context "when the file doesn't fit in 2 units" do
          let(:size) { 2 * 4096 + 1}
          it { is_expected.to eq 24 } # 24 * 512b blocks = 3 * 4kB units
        end

        context "when the file doesn't fit in multiple units" do
          let(:size) { 50_000 }
          it { is_expected.to eq 104 }  # 13 * 4k units = 140 * 512 byte blocks
        end
      end

      context "when blksize is 256" do
        before do
          # NOTE: 256 means an actual filesystem allocation unit of 2048
          allow(Aruba.config).to receive(:physical_block_size).and_return(256)
        end

        context "when file is empty" do
          let(:size) { 0 }
          it { is_expected.to eq 8 }
        end

        context "when file is tiny" do
          let(:size) { 1 }
          it { is_expected.to eq 8 } # 8 * 256 = 2kB block
        end

        context "when the file fits in the configure block size" do
          let(:size) { 2048 - 1 }
          it { is_expected.to eq 8 }
        end

        context "when the file barely fits in the configured block size" do
          let(:size) { 2048 }
          it { is_expected.to eq 8 } # 8 Aruba-sized blocks = (2kB)
        end

        context "when the file doesn't fit in the configured block size" do
          let(:size) { 2048 + 1 }
          it { is_expected.to eq 16 } # 16 Aruba-sized blocks = 2 * 2kB units
        end

        context "when the file doesn't fit in 2 blocks of configured size" do
          let(:size) { 2 * 2048 + 1 }
          it { is_expected.to eq 24 } # 24 * 256b blocks = 3 * 2048b units
        end

        context "when the file doesn't fit in more blocks of configured size" do
          let(:size) { 12 * 2048 + 1 }
          it { is_expected.to eq 104 } # 104 * 256b blocks =  13 * 4kB units
        end
      end
    end
  end
end
