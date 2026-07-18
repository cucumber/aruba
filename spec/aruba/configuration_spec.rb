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

  describe '#command_launcher=' do
    it 'allows only a limited set of values' do
      aggregate_failures do
        %i[in_process spawn debug].each do |value|
          expect { config.command_launcher = value }.not_to raise_error
        end
        expect { config.command_launcher = :potato }.to raise_error ParamContractError
        expect { config.command_launcher = nil }.to raise_error ParamContractError
      end
    end
  end

  describe '#log_level=' do
    it 'allows only a limited set of values' do
      aggregate_failures do
        expect { config.log_level = :warn }.not_to raise_error
        expect { config.log_level = :potato }.to raise_error ParamContractError
        expect { config.log_level = nil }.to raise_error ParamContractError
      end
    end
  end
end
