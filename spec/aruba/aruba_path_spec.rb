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
end
