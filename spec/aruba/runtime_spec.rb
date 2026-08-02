# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Aruba::Runtime do
  describe '#config' do
    it 'is a (wrapped) copy of the main configuration by default' do
      runtime = described_class.new
      runtime.config.log_level = :debug
      expect(Aruba.config.log_level).to eq :info
    end

    it 'uses the passed in config if passed explicitly' do
      config = Aruba::Configuration.new
      config.log_level = :fatal
      runtime = described_class.new(config: config)
      expect(runtime.config.log_level).to eq :fatal
    end

    it 'makes a copy of the passed-in config' do
      config = Aruba::Configuration.new
      runtime = described_class.new(config: config)
      runtime.config.log_level = :debug
      expect(config.log_level).to eq :info
    end
  end

  describe '#fixtures_directory' do
    let(:runtime) { described_class.new }

    context 'when no fixtures directories exist' do
      before do
        runtime.config.fixtures_directories = ['not-there', 'not/here', 'does/not/exist']
      end

      it 'raises exception' do
        expect { runtime.fixtures_directory }
          .to raise_error RuntimeError, /No existing fixtures directory found/
      end
    end

    context 'when one of the configures fixture directories exists' do
      before do
        runtime.config.fixtures_directories = ['not-there', 'fixtures', 'does/not/exist']
      end

      it 'returns that directory' do
        expect(runtime.fixtures_directory.to_s).to eq File.expand_path('fixtures',
                                                                       runtime.root_directory)
      end
    end
  end

  describe '#setup' do
    let(:config) { Aruba::Configuration.new }

    it 'creates a new unique workspace directory' do
      one = described_class.new(config: config)
      two = described_class.new(config: config)

      one.setup
      two.setup

      aggregate_failures do
        expect(one.working_directory).to start_with 'tmp/aruba-'
        expect(two.working_directory).to start_with 'tmp/aruba-'
        expect(one.working_directory).not_to eq two.working_directory
      end
    ensure
      one.teardown
      two.teardown
    end
  end

  describe '#working_directory' do
    let(:config) { Aruba::Configuration.new }

    it 'is set based on the configured working_directory_suffix' do
      config.working_directory_suffix = 'foo'
      runtime = described_class.new(config: config)
      runtime.setup

      expect(runtime.working_directory).to start_with 'tmp/foo-'
    ensure
      runtime.teardown
    end

    it 'is not reset after setup' do
      config.working_directory_suffix = 'foo'
      runtime = described_class.new(config: config)
      runtime.config.working_directory_suffix = 'bar'
      runtime.setup
      runtime.config.working_directory_suffix = 'baz'

      expect(runtime.working_directory).to start_with 'tmp/bar-'
    ensure
      runtime.teardown
    end

    it 'cannot escape the tmp directory' do
      expect { config.working_directory_suffix = '../foo' }.to raise_error ParamContractError
    end

    it 'cannot be set to an absolut path' do
      expect { config.working_directory_suffix = '/foo' }.to raise_error ParamContractError
    end
  end
end
