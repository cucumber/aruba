require 'spec_helper'

RSpec.describe Aruba::InConfigWrapper do
  subject(:wrapper) { described_class.new(config) }

  let(:config) { {} }

  context 'when option is defined' do
    before :each do
      config[:opt] = true
    end

    context 'when valid' do
      it { expect(wrapper.opt).to be true }
    end

    context 'when one tries to pass arguments to option' do
      it { expect{ wrapper.opt('arg') }.to raise_error ArgumentError, 'Options take no argument' }
    end
  end

  context 'when option is not defined' do
    it { expect{ wrapper.opt }.to raise_error ArgumentError, 'Option "opt" is unknown. Please use only earlier defined options' }
  end
end
