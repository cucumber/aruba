require 'spec_helper'

RSpec.describe 'aruba' do
  describe '#config' do
    subject(:config) { aruba.config }

    if RUBY_VERSION >= '1.9'
      context 'when initialized' do
        it { is_expected.to eq Aruba.config }
      end
    end

    context 'when changed earlier' do
      context 'values when init' do
        let(:value) { 20 }
        before(:each) { aruba.config.io_wait_timeout = value }

        it { expect(config.io_wait_timeout).to eq value }
      end

      context 'default value' do
        let(:value) { 0.1 } # Aruba.config.io_wait_timeout

        it { expect(config.io_wait_timeout).to eq value }
      end
    end
  end
end
