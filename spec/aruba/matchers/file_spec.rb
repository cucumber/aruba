require 'spec_helper'

RSpec.describe 'File Matchers' do
  include_context 'uses aruba API'

  def absolute_path(*args)
    @aruba.absolute_path(*args)
  end

  describe 'to_be_exsting_file' do
    context 'when file exists' do
      before :each do
        File.write(@file_path, '')
      end

      it { expect(@file_name).to be_existing_file }
    end

    context 'when file does not exist' do
      it { expect(@file_name).not_to be_existing_file }
    end
  end
end
