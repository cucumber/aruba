require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe '#copy' do
    let(:source) { 'file.txt' }
    let(:destination) { 'file1.txt' }

    context 'when source is existing' do
      context 'when destination is non-existing' do
        context 'when source is file' do
          before(:each) { create_test_files(source) }

          before :each do
            @aruba.copy source, destination
          end

          context 'when source is plain file' do
            it { expect(destination).to be_an_existing_file }
          end

          context 'when source is contains "~" in path' do
            let(:source) { '~/file.txt' }
            it { expect(destination).to be_an_existing_file }
          end

          context 'when source is fixture' do
            let(:source) { '%/copy/file.txt' }
            let(:destination) { 'file.txt' }
            it { expect(destination).to be_an_existing_file }
          end

          context 'when source is list of files' do
            let(:source) { %w(file1.txt file2.txt file3.txt) }
            let(:destination) { 'file.d' }
            let(:destination_files) { source.map { |s| File.join(destination, s) } }

            it { expect(destination_files).to all be_an_existing_file }
          end
        end

        context 'when source is directory' do
          let(:source) { 'src.d' }
          let(:destination) { 'dst.d' }

          before :each do
            Aruba.platform.mkdir(File.join(@aruba.aruba.current_directory, source))
          end

          before :each do
            @aruba.copy source, destination
          end

          context 'when source is single directory' do
            it { expect(destination).to be_an_existing_directory }
          end

          context 'when source is nested directory' do
            let(:source) { 'src.d/subdir.d' }
            let(:destination) { 'dst.d/' }

            it { expect(destination).to be_an_existing_directory }
          end
        end
      end

      context 'when destination is existing' do
        context 'when source is list of files' do
          before(:each) { create_test_files(source) }

          context 'when destination is directory' do
            let(:source) { %w(file1.txt file2.txt file3.txt) }
            let(:destination) { 'file.d' }
            let(:destination_files) { source.map { |s| File.join(destination, s) } }

            before :each do
              Aruba.platform.mkdir(File.join(@aruba.aruba.current_directory, destination))
            end

            before :each do
              @aruba.copy source, destination
            end

            it { source.each { |s| expect(destination_files).to all be_an_existing_file } }
          end

          context 'when destination is not a directory' do
            let(:source) { %w(file1.txt file2.txt file3.txt) }
            let(:destination) { 'file.txt' }

            before(:each) { create_test_files(destination) }

            it { expect { @aruba.copy source, destination }.to raise_error ArgumentError, "Multiples sources can only be copied to a directory" }
          end

          context 'when a source is the same like destination' do
            let(:source) { 'file1.txt' }
            let(:destination) { 'file1.txt' }

            before(:each) { create_test_files(source) }

            # rubocop:disable Metrics/LineLength
            it { expect { @aruba.copy source, destination }.to raise_error ArgumentError, %(same file: #{File.expand_path(File.join(@aruba.aruba.current_directory, source))} and #{File.expand_path(File.join(@aruba.aruba.current_directory, destination))}) }
            # rubocop:enable Metrics/LineLength
          end

          context 'when a fixture is destination' do
            let(:source) { '%/copy/file.txt' }
            let(:destination) { '%/copy/file.txt' }

            it { expect { @aruba.copy source, destination }.to raise_error ArgumentError, "Using a fixture as destination (#{destination}) is not supported" }
          end
        end
      end

      context 'when source is non-existing' do
        it { expect { @aruba.copy source, destination }.to raise_error ArgumentError}
      end
    end
  end
end
