require 'spec_helper'

RSpec.describe Aruba::Runtime do
  describe '#fixtures_directory' do
    let(:api) do
      klass = Class.new do
        include Aruba::Api

        def root_directory
          expand_path('.')
        end
      end

      klass.new
    end

    context 'when no fixtures directories exist' do
      it 'raises exception' do
        expect { api.fixtures_directory }.to raise_error
      end
    end

    context 'when "/features/fixtures"-directory exist' do
      it {
        pending('These tests need fixing and classifying')
        api.create_directory('features/fixtures')
        expect(api.fixtures_directory).to eq expand_path('features/fixtures')
      }
    end

    context 'when "/spec/fixtures"-directory exist' do
      it {
        pending('These tests need fixing and classifying')
        api.create_directory('spec/fixtures')
        expect(api.fixtures_directory).to eq expand_path('spec/fixtures')
      }
    end

    context 'when "/test/fixtures"-directory exist' do
      it {
        pending('These tests need fixing and classifying')
        api.create_directory('test/fixtures')
        expect(api.fixtures_directory.to_s).to eq expand_path('test/fixtures')
      }
    end
  end
end
