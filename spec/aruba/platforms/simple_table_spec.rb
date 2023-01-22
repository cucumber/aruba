# frozen_string_literal: true

require 'spec_helper'
require 'aruba/platform'

RSpec.describe Aruba::Platforms::SimpleTable do
  describe '#to_s' do
    it 'renders a sorted table of the provided hash' do
      hash = {
        key2: 'value',
        key1: 'value'
      }

      expect(described_class.new(hash).to_s).to eq <<~TABLE.chomp
        # key1 => value
        # key2 => value
      TABLE
    end

    it 'renders an unsorted table provided hash unsorted if requested' do
      hash = {
        key2: 'value',
        key1: 'value'
      }

      expect(described_class.new(hash, sort: false).to_s).to eq <<~TABLE.chomp
        # key2 => value
        # key1 => value
      TABLE
    end

    it 'renders an empty string if the provided hash is empty' do
      hash = {}

      expect(described_class.new(hash).to_s).to eq ''
    end

    it 'aligns values when key lengths are unequal' do
      hash = {
        key1: 'value',
        long_key2: 'value'
      }

      expect(described_class.new(hash).to_s).to eq <<~TABLE.chomp
        # key1      => value
        # long_key2 => value
      TABLE
    end
  end
end
