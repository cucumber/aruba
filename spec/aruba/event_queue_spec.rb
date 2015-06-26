require 'spec_helper'

RSpec.describe EventQueue do
  subject(:queue) { described_class.new }

  let(:listener) { double('Listener') }

  context 'when valid listener' do
    before :each do
      expect(listener).to receive(:notify)
    end

    before :each do
      queue.register :event1, listener
    end

    it { queue.notify :event1, 'Hello World' }
  end
end
