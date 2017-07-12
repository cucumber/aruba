require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe '#touch' do
    let(:name) { @file_name }
    let(:path) { @file_path }
    let(:options) { {} }

    before :each do
      @aruba.set_environment_variable 'HOME', File.expand_path(@aruba.aruba.current_directory)
    end

    context 'when file' do
      before :each do
        @aruba.touch(name, options)
      end

      context 'when does not exist' do
        context 'and should be created in existing directory' do
          it { expect(File.size(path)).to eq 0 }
          it_behaves_like 'an existing file'
        end

        context 'and should be created in non-existing directory' do
          let(:name) { 'directory/test' }
          let(:path) { File.join(@aruba.aruba.current_directory, 'directory/test') }

          it_behaves_like 'an existing file'
        end

        context 'and path includes ~' do
          let(:string) { random_string }
          let(:name) { File.join('~', string) }
          let(:path) { File.join(@aruba.aruba.current_directory, string) }

          it_behaves_like 'an existing file'
        end

        context 'and the mtime should be set statically' do
          let(:time) { Time.parse('2014-01-01 10:00:00') }
          let(:options) { { :mtime => Time.parse('2014-01-01 10:00:00') } }

          it_behaves_like 'an existing file'
          it { expect(File.mtime(path)).to eq time }
        end

        context 'and multiple file names are given' do
          let(:name) { %w(file1 file2 file3) }
          let(:path) { %w(file1 file2 file3).map { |p| File.join(@aruba.aruba.current_directory, p) } }
          it_behaves_like 'an existing file'
        end
      end
    end

    context 'when directory' do
      let(:name) { %w(directory1) }
      let(:path) { Array(name).map { |p| File.join(@aruba.aruba.current_directory, p) } }

      context 'when exist' do
        before(:each) { Array(path).each { |p| Aruba.platform.mkdir p } }

        before :each do
          @aruba.touch(name, options)
        end

        context 'and the mtime should be set statically' do
          let(:time) { Time.parse('2014-01-01 10:00:00') }
          let(:options) { { :mtime => Time.parse('2014-01-01 10:00:00') } }

          it_behaves_like 'an existing directory'
          it { Array(path).each { |p| expect(File.mtime(p)).to eq time } }
        end
      end
    end
  end
end
