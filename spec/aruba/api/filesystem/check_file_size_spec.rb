require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

    context '#check_file_size' do
      it "should check an existing file size" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        @aruba.check_file_size([[@file_name, @file_size]])
      end

      it "should check an existing file size and fail" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        expect { @aruba.check_file_size([[@file_name, @file_size + 1]]) }.to raise_error
      end

      it "works with ~ in path name" do
        file_path = File.join('~', random_string)

        @aruba.with_environment 'HOME' => File.expand_path(aruba.current_directory) do
          @aruba.write_fixed_size_file(file_path, @file_size)
          @aruba.check_file_size([[file_path, @file_size]])
        end
      end

      it "should check an existing file size and fail" do
        @aruba.write_fixed_size_file(@file_name, @file_size)
        expect { @aruba.check_file_size([[@file_name, @file_size + 1]]) }.to raise_error
      end
    end

end
