require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

  context '#write_file' do
    it 'writes file' do
      @aruba.write_file(@file_name, '')

      expect(File.exist?(@file_path)).to eq true
    end
  end
end
