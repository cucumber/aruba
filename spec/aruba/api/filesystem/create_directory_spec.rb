require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  describe 'directories' do
    before(:each) do
      @directory_name = 'test_dir'
      @directory_path = File.join(@aruba.aruba.current_directory, @directory_name)
    end

    context '#create_directory' do
      it 'creates a directory' do
        @aruba.create_directory @directory_name
        expect(File.exist?(File.expand_path(@directory_path))).to be_truthy
      end
    end
  end
end
