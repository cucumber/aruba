require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe '#all_directories' do
    let(:name) { @file_name }
    let(:path) { @file_path }

    context 'when file exist' do
      before :each do
        Aruba.platform.write_file(path, '')
      end

      it { expect(all_directories).to eq [] }
    end

    context 'when directory exist' do
      let(:name) { 'test_dir' }
      let(:path) { File.join(@aruba.aruba.current_directory, name) }

      before :each do
        Aruba.platform.mkdir(path)
      end

      it { expect(all_directories).to include expand_path(name) }
    end

    context 'when nothing exist' do
      it { expect(all_directories).to eq [] }
    end
  end
end
