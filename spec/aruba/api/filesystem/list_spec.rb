require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe '#list' do
    let(:name) { 'test.d' }
    let(:content) { %w(subdir.1.d subdir.2.d) }
    let(:path) { File.join(@aruba.aruba.current_directory, name) }

    before :each do
      @aruba.set_environment_variable 'HOME', File.expand_path(@aruba.aruba.current_directory)
    end

    context 'when does not exist' do
      it { expect { @aruba.list(name) }.to raise_error ArgumentError }
    end

    context 'when exists' do
      context 'when file' do
        let(:name) { 'test.txt' }

        before :each do
          File.open(File.expand_path(path), 'w') { |f| f << content }
        end

        context 'when normal file' do
          it { expect{ @aruba.list(name) }.to raise_error ArgumentError }
        end
      end

      context 'when directory' do
        before :each do
          Array(path).each { |p| Aruba.platform.mkdir p }
        end

        before :each do
          Array(content).each { |p| Aruba.platform.mkdir File.join(path, p) }
        end

        context 'when has subdirectories' do
          context 'when is simple path' do
            let(:existing_files) { @aruba.list(name) }
            let(:expected_files) { content.map { |c| File.join(name, c) }.sort }

            it { expect(expected_files - existing_files).to be_empty}
          end

          context 'when path contains ~' do
            let(:string) { random_string }
            let(:name) { File.join('~', string) }
            let(:path) { File.join(@aruba.aruba.current_directory, string) }

            let(:existing_files) { @aruba.list(name) }
            let(:expected_files) { content.map { |c| File.join(string, c) } }

            it { expect(expected_files - existing_files).to be_empty}
          end
        end

        context 'when has no subdirectories' do
          let(:content) { [] }
          it { expect(@aruba.list(name)).to eq [] }
        end
      end
    end
  end
end
