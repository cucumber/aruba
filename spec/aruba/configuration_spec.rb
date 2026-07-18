# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Aruba::Configuration do
  let(:config) { described_class.new }

  it_behaves_like 'a basic configuration'

  describe '#fixtures_directories=' do
    it 'does not allow bad values' do
      expect { config.fixtures_directories = [1, 2] }.to raise_error ParamContractError
    end
  end

  describe '#working_directory_suffix=' do
    it 'can be set to a single path segment' do
      expect { config.working_directory_suffix = 'foo' }.not_to raise_error
    end

    it 'cannot be set to "."' do
      expect { config.working_directory_suffix = '.' }.to raise_error ParamContractError
    end

    it 'cannot go up the path' do
      aggregate_failures do
        ['..', '../foo'].each do |suffix|
          expect { config.working_directory_suffix = suffix }
            .to raise_error ParamContractError
        end
      end
    end

    it 'must represent a single path segment' do
      expect { config.working_directory_suffix = 'foo/bar' }
        .to raise_error ParamContractError
    end
  end
end
