require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe '#read' do
    let(:name) { 'test.txt'}
    let(:path) { File.join(@aruba.aruba.current_directory, name) }
    let(:content) { 'asdf' }

    before :each do
      @aruba.set_environment_variable 'HOME', File.expand_path(@aruba.aruba.current_directory)
    end

    context 'when does not exist' do
      it { expect { @aruba.read(name) }.to raise_error ArgumentError }
    end

    context 'when exists' do
      context 'when file' do
        before :each do
          File.open(File.expand_path(path), 'w') { |f| f << content }
        end

        context 'when normal file' do
          it { expect(@aruba.read(name)).to eq [content] }
        end

        context 'when binary file' do
          let(:content) { "\u0000" }
          it { expect(@aruba.read(name)).to eq [content] }
        end

        context 'when is empty file' do
          let(:content) { '' }
          it { expect(@aruba.read(name)).to eq [] }
        end

        context 'when path contains ~' do
          let(:string) { random_string }
          let(:name) { File.join('~', string) }
          let(:path) { File.join(@aruba.aruba.current_directory, string) }

          it { expect(@aruba.read(name)).to eq [content] }
        end
      end

      context 'when directory' do
        let(:name) { 'test.d' }

        before :each do
          Array(path).each { |p| Aruba.platform.mkdir p }
        end

        it { expect { @aruba.read(name) }.to raise_error ArgumentError }
      end
    end
  end
end
