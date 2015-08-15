require 'spec_helper'

RSpec.describe 'Output Matchers' do
  include_context 'uses aruba API'

  def expand_path(*args)
    @aruba.expand_path(*args)
  end

  describe '#to_have_output_size' do
    let(:obj) { 'string' }

    context 'when has size' do
      context 'when is string' do
        it { expect(obj).to have_output_size 6 }
      end
    end

    context 'when does not have size' do
      let(:obj) { 'string' }

      it { expect(obj).not_to have_output_size(-1) }
    end
  end
end
