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
end
