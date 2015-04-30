require 'spec_helper'

RSpec.describe 'Directory Matchers' do
  include_context 'uses aruba API'

  def expand_path(*args)
    @aruba.expand_path(*args)
  end

  describe 'to_be_existing_directory' do
    let(:name) { 'test.d' }
    let(:path) { File.join(@aruba.current_directory, name) }

    context 'when directory exists' do
      before :each do
        FileUtils.mkdir_p path
      end

      it { expect(name).to be_existing_directory }
    end

    context 'when directory does not exist' do
      it { expect(name).not_to be_existing_directory }
    end
  end
end
