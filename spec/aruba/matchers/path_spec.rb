require 'spec_helper'

require 'fileutils'
require 'aruba/matchers/path'

RSpec.describe 'Path Matchers' do
  include_context 'uses aruba API'

  def expand_path(*args)
    @aruba.expand_path(*args)
  end

  describe 'to_be_an_absolute_path' do
    let(:name) { @file_name }
    let(:path) { @aruba.expand_path(name) }

    context 'when is absolute path' do
      it { expect(path).to be_an_absolute_path }
    end

    context 'when is relative path' do
      it { expect(name).not_to be_an_absolute_path }
    end
  end

  describe 'to_be_an_existing_path' do
    context 'when file' do
      context 'exists' do
        before :each do
          Aruba.platform.write_file(@file_path, '')
        end

        it { expect(@file_name).to be_an_existing_path }
      end

      context 'does not exist' do
        it { expect(@file_name).not_to be_an_existing_path }
      end
    end

    context 'when directory' do
      let(:name) { 'test.d' }
      let(:path) { @aruba.expand_path(name) }

      context 'exists' do
        before :each do
          FileUtils.mkdir_p path
        end

        it { expect(name).to be_an_existing_path }
      end

      context 'does not exist' do
        it { expect(name).not_to be_an_existing_path }
      end
    end
  end

  describe 'to have_permissions' do
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
      @aruba.chmod(permissions, file_name)
    end

    context 'when file exists' do
      context 'and should have permissions' do
        context 'and permissions are given as string' do
          it { expect(file_name).to have_permissions permissions }
        end

        context 'and permissions are given as octal number' do
          let(:permissions) { 0o644 }

          it { expect(file_name).to have_permissions permissions }
        end

        context 'and path includes ~' do
          let(:string) { random_string }
          let(:file_name) { File.join('~', string) }
          let(:file_path) { File.join(@aruba.aruba.current_directory, string) }

          it { expect(file_name).to have_permissions permissions }
        end

        context 'but fails because the permissions are different' do
          let(:expected_permissions) { 0o666 }

          it do
            expect { expect(file_name).to have_permissions expected_permissions }
              .to raise_error RSpec::Expectations::ExpectationNotMetError
          end
        end
      end

      context 'and should not have permissions' do
        context 'and succeeds when the difference is expected and permissions are different' do
          let(:different_permissions) { 0o666 }

          it { expect(file_name).not_to have_permissions different_permissions }
        end

        context 'and fails because the permissions are the same although they should be different' do
          let(:different_permissions) { 0o644 }

          it do
            expect { expect(file_name).not_to have_permissions different_permissions }
              .to raise_error RSpec::Expectations::ExpectationNotMetError
          end
        end
      end
    end
  end
end
