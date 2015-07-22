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

    before(:each) { FileUtils.mkdir_p File.dirname(new_path) }
    before(:each) { File.open(new_path, 'w') { |f| f.print 'a' } }

    it { expect(path.blocks).to be > 0 }
  end
end
