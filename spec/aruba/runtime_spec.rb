require 'spec_helper'

RSpec.describe Aruba::Runtime do
  include_context 'uses aruba API'

  describe '#fixtures_directory' do
    let(:runtime) do
      @aruba.aruba
    end

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
end
