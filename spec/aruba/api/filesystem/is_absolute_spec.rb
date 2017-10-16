require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe '#absolute?' do
    let(:name) { @file_name }
    let(:path) { File.expand_path(File.join(@aruba.aruba.current_directory, name)) }

    context 'when is absolute path' do
      it { expect(@aruba).to be_absolute(path) }
    end

    context 'when is relative path' do
      it { expect(@aruba).not_to be_absolute(name) }
    end
  end
end
