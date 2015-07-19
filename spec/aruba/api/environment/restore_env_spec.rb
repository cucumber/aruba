require 'spec_helper'

RSpec.describe 'Command Environment' do
  include_context 'uses aruba API'

  around do |example|
    old_env = ENV.to_h
    example.run
    ENV.update(old_env)
  end

  describe '#restore_env' do
    context 'when non-existing variable' do
      before :each do
        ENV.delete 'LONG_LONG_ENV_VARIABLE'
      end

      context 'when set single' do
        before :each do
          @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', '1'
          @aruba.restore_env
        end

        it { expect(ENV).not_to be_key 'LONG_LONG_ENV_VARIABLE' }
      end

      context 'when set multiple times' do
        before :each do
          @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', '1'
          @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', '2'
          @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', '3'
          @aruba.restore_env
        end

        it { expect(ENV).not_to be_key 'LONG_LONG_ENV_VARIABLE' }
      end
    end

    context 'when existing variable from outer context' do
      before :each do
        ENV['LONG_LONG_ENV_VARIABLE'] = '0'
      end

      context 'when set single time' do
        before :each do
          @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', '1'
          @aruba.restore_env
        end

        it { expect(ENV['LONG_LONG_ENV_VARIABLE']).to eq '0' }
      end

      context 'when set multiple times' do
        before :each do
          @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', '1'
          @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', '2'
          @aruba.set_environment_variable 'LONG_LONG_ENV_VARIABLE', '3'
          @aruba.restore_env
        end

        it { expect(ENV['LONG_LONG_ENV_VARIABLE']).to eq '0' }
      end
    end
  end
end
