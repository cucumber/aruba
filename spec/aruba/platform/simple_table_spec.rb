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
    let(:rows) { ['# key1 => value', '# key2 => value'] }

    it { expect(Aruba.platform.simple_table(hash).to_s).to eq rows.join("\n") }
  end

  context 'when empty hash' do
    let(:hash) { {} }
    let(:rows) { [] }

    it { expect(Aruba.platform.simple_table(hash).to_s).to eq rows.join("\n") }
  end
end
