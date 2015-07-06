require 'spec_helper'

RSpec.describe 'RSpec Integration', :type => :aruba do
  describe 'Configuration' do
    subject(:config) { aruba.config }

    context 'when io_wait_timeout is 0.5', :io_wait_timeout => 0.5 do
      it { expect(config.io_wait_timeout).to eq 0.5 }
    end

    context 'when io_wait_timeout is 0.1' do
      it { expect(config.io_wait_timeout).to eq 0.1 }
    end
  end
end
