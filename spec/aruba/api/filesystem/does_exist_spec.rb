require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe '#exist?' do
    context 'when is file' do
      let(:name) { @file_name }
      let(:path) { @file_path }

      context 'when exists' do
        before :each do
          Aruba.platform.write_file(path, '')
        end

        it { expect(@aruba).to be_exist(name) }
      end

      context 'when does not exist' do
        it { expect(@aruba).not_to be_exist(name) }
      end
    end

    context 'when is directory' do
      let(:name) { 'test.d' }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      context 'when exists' do
        before :each do
          Aruba.platform.mkdir(path)
        end

        it { expect(@aruba).to be_exist(name) }
      end

      context 'when does not exist' do
        it { expect(@aruba).not_to be_exist(name) }
      end
    end
  end
end
