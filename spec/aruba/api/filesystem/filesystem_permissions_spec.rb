require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

    describe '#filesystem_permissions' do
      def actual_permissions
        format( "%o" , File::Stat.new(file_path).mode )[-4,4]
      end

      let(:file_name) { @file_name }
      let(:file_path) { @file_path }
      let(:permissions) { '0644' }

      before :each do
        @aruba.set_environment_variable 'HOME', File.expand_path(@aruba.aruba.current_directory)
      end

      before(:each) do
        File.open(file_path, 'w') { |f| f << "" }
      end

      before(:each) do
        @aruba.filesystem_permissions(permissions, file_name)
      end

      context 'when file exists' do
        context 'and permissions are given as string' do
          it { expect(actual_permissions).to eq('0644') }
        end

        context 'and permissions are given as octal number' do
          let(:permissions) { 0o644 }
          it { expect(actual_permissions).to eq('0644') }
        end

        context 'and path has ~ in it' do
          let(:path) { random_string }
          let(:file_name) { File.join('~', path) }
          let(:file_path) { File.join(@aruba.aruba.current_directory, path) }

          it { expect(actual_permissions).to eq('0644') }
        end
      end
    end
    end
