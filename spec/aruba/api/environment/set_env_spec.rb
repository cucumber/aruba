require 'spec_helper'

RSpec.describe 'Command Environment' do
  include_context 'uses aruba API'

  around do |example|
    Aruba.platform.with_environment do
      example.run
    end
  end

  before do
    allow(Aruba.platform).to receive(:deprecated)
  end

  describe '#set_env' do
    context 'when non-existing variable' do
      before :each do
        ENV.delete('LONG_LONG_ENV_VARIABLE')
      end

      context 'when string' do
        before :each do
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '1'
        end

        it { expect(ENV['LONG_LONG_ENV_VARIABLE']).to eq '1' }
      end
    end

    context 'when existing variable set by aruba' do
      before :each do
        @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '1'
        @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '2'
      end

      it { expect(ENV['LONG_LONG_ENV_VARIABLE']).to eq '2' }
    end

    context 'when existing variable by outer context' do
      before :each do
        ENV['LONG_LONG_ENV_VARIABLE'] = '1'
      end
    end
  end
end
