require 'spec_helper'
require 'aruba/aruba_path'

RSpec.describe Aruba::ArubaPath do
  describe '#pop' do
    it 'pops a previously pushed path element' do
      path = described_class.new('path/to/dir')
      path.push 'subdir'
      popped = path.pop

      aggregate_failures do
        expect(popped).to eq 'subdir'
        expect(path.to_s).to eq 'path/to/dir'
      end
    end
  end

  describe '#to_s' do
    it 'returns the path given in the initializer' do
      path = described_class.new('path/to/dir')
      expect(path.to_s).to eq 'path/to/dir'
    end

    it 'combines pushed relative path elements' do
      path = described_class.new('path/to')
      path << 'dir'
      expect(path.to_s).to eq 'path/to/dir'
    end

    it 'replaces earlier elements when an absolute path was pushed' do
      path = described_class.new('path/to')
      path << '/foo'
      expect(path.to_s).to eq '/foo'
    end

    it 'replaces earlier elements when a home directory-relative path was pushed' do
      path = described_class.new('path/to')
      path << '~/foo'
      expect(path.to_s).to eq '~/foo'
    end
  end

  describe '#[]' do
    let(:path) { described_class.new('path/to/dir') }

    context 'when single index' do
      it { expect(path[0]).to eq 'p' }
    end

    context 'when range' do
      it { expect(path[0..1]).to eq 'pa' }
    end
  end
end
