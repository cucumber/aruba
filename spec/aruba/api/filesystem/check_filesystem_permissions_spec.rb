require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe '#check_filesystem_permissions' do
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
      context 'and should have permissions' do
        context 'and permissions are given as string' do
          it { @aruba.check_filesystem_permissions(permissions, file_name, true) }
        end

        context 'and permissions are given as octal number' do
          let(:permissions) { 0o666 }

          it { @aruba.check_filesystem_permissions(permissions, file_name, true) }
        end

        context 'and path includes ~' do
          let(:string) { random_string }
          let(:file_name) { File.join('~', string) }
          let(:file_path) { File.join(@aruba.aruba.current_directory, string) }

          it { @aruba.check_filesystem_permissions(permissions, file_name, true) }
        end

        context 'but fails because the permissions are different' do
          let(:expected_permissions) { 0o666 }

          it { expect { @aruba.check_filesystem_permissions(expected_permissions, file_name, true) }.to raise_error }
        end
      end

      context 'and should not have permissions' do
        context 'and succeeds when the difference is expected and permissions are different' do
          let(:different_permissions) { 0o666 }

          it { @aruba.check_filesystem_permissions(different_permissions, file_name, false) }
        end

        context 'and fails because the permissions are the same although they should be different' do
          let(:different_permissions) { 0o644 }

          it { expect { @aruba.check_filesystem_permissions(different_permissions, file_name, false) }.to raise_error }
        end
      end
    end
  end
end
