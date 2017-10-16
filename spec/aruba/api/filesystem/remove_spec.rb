require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe '#remove' do
    let(:name) { 'test.txt'}
    let(:path) { File.join(@aruba.aruba.current_directory, name) }
    let(:options) { {} }

    before :each do
      @aruba.set_environment_variable 'HOME', File.expand_path(@aruba.aruba.current_directory)
    end

    context 'when file' do
      context 'when exists' do
        before :each do
          Array(path).each { |p| File.open(File.expand_path(p), 'w') { |f| f << "" } }
        end

        before :each do
          @aruba.remove(name, options)
        end

        context 'when is a single file' do
          it_behaves_like 'a non-existing file'
        end

        context 'when are multiple files' do
          let(:file_name) { %w(file1 file2 file3) }
          let(:file_path) { %w(file1 file2 file3).map { |p| File.join(@aruba.aruba.current_directory, p) } }

          it_behaves_like 'a non-existing file'
        end

        context 'when path contains ~' do
          let(:string) { random_string }
          let(:file_name) { File.join('~', string) }
          let(:file_path) { File.join(@aruba.aruba.current_directory, string) }

          it_behaves_like 'a non-existing file'
        end
      end

      context 'when does not exist' do
        before :each do
          @aruba.remove(name, options)
        end

        context 'when is forced to delete file' do
          let(:options) { { :force => true } }

          it_behaves_like 'a non-existing file'
        end
      end
    end

    context 'when is directory' do
      let(:name) { 'test.d' }

      context 'when exists' do
        before :each do
          Array(path).each { |p| Aruba.platform.mkdir p }
        end

        before :each do
          @aruba.remove(name, options)
        end

        context 'when is a single directory' do
          it_behaves_like 'a non-existing directory'
        end

        context 'when are multiple directorys' do
          let(:directory_name) { %w(directory1 directory2 directory3) }
          let(:directory_path) { %w(directory1 directory2 directory3).map { |p| File.join(@aruba.aruba.current_directory, p) } }

          it_behaves_like 'a non-existing directory'
        end

        context 'when path contains ~' do
          let(:string) { random_string }
          let(:directory_name) { File.join('~', string) }
          let(:directory_path) { File.join(@aruba.aruba.current_directory, string) }

          it_behaves_like 'a non-existing directory'
        end
      end

      context 'when does not exist' do
        before :each do
          @aruba.remove(name, options)
        end

        context 'when is forced to delete directory' do
          let(:options) { { :force => true } }

          it_behaves_like 'a non-existing directory'
        end
      end
    end
  end
end
