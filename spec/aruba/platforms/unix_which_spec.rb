# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Aruba::Platforms::UnixWhich do
  let(:which) { described_class.new }

  describe '#call' do
    it 'returns nil if the program cannot be found' do
      program = 'foobar'
      expect(which.call(program)).to be_nil
    end

    it 'returns nil for a bare program name if path is nil' do
      program = 'foobar'
      expect(which.call(program, nil)).to be_nil
    end
  end
end
