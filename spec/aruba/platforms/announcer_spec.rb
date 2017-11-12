require 'spec_helper'
require 'aruba/platforms/announcer'

RSpec.describe Aruba::Platforms::Announcer do
  let(:announcer) { described_class.new }

  describe '#mode=' do
    it 'sets the mode to :puts' do
      announcer.mode = :puts
      expect(announcer.mode).to eq :puts
    end

    it 'sets the mode to :kernel_puts' do
      announcer.mode = :kernel_puts
      expect(announcer.mode).to eq :kernel_puts
    end
  end
end
