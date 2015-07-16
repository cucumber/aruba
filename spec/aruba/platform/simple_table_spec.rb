require 'spec_helper'
require 'aruba/platform'

RSpec.describe '.simple_table' do
  context 'when valid hash' do
    let(:hash) do
      {
        :key1 => 'value',
        :key2 => 'value'
      }
    end
    let(:rows) { ['key1 => value', 'key2 => value'] }

    it { expect(Aruba::Platform.simple_table(hash)).to eq rows }
  end
end
