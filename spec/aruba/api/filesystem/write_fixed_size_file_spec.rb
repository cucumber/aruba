require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  context '#write_fixed_size_file' do
    it "should write a fixed sized file" do
      @aruba.write_fixed_size_file(@file_name, @file_size)
      expect(File.exist?(@file_path)).to eq true
      expect(File.size(@file_path)).to eq @file_size
    end

    it "works with ~ in path name" do
      file_path = File.join('~', random_string)

      @aruba.with_environment 'HOME' => File.expand_path(aruba.current_directory) do
        @aruba.write_fixed_size_file(file_path, @file_size)

        expect(File.exist?(File.expand_path(file_path))).to eq true
        expect(File.size(File.expand_path(file_path))).to eq @file_size
      end
    end
  end
end
