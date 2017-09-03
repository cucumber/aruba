require 'spec_helper'

RSpec.describe 'Filesystem Api' do
  include_context 'uses aruba API'

  def expand_path(*args)
    @aruba.expand_path(*args)
  end

  describe '#file_size' do
    let(:name) { @file_name }
    let(:path) { @file_path }
    let(:size) { file_size(name) }

    context 'when file exist' do
      before :each do
        File.open(path, 'w') { |f| f.print 'a' }
      end

      it { expect(size).to eq 1 }
    end

    context 'when file does not exist' do
      let(:name) { 'non_existing_file' }
      it { expect { size }.to raise_error RSpec::Expectations::ExpectationNotMetError }
    end
  end
end
