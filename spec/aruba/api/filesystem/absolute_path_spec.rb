require 'spec_helper'
require 'securerandom'
require 'aruba/api'
require 'fileutils'

describe Aruba::Api do
  include_context 'uses aruba API'

    context '#absolute_path' do
      context 'when file_name is array of path names' do
        it { silence(:stderr) { expect(@aruba.absolute_path(['path', @file_name])).to eq File.expand_path(File.join(aruba.current_directory, 'path', @file_name)) } }
      end
    end
end
