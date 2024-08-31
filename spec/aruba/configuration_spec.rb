# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Aruba::Configuration do
  it_behaves_like 'a basic configuration'

  context 'when is modified' do
    let(:config) { described_class.new }

    it 'does not allow bad values' do
      expect { config.fixtures_directories = [1, 2] }.to raise_error ParamContractError
    end
  end
end
