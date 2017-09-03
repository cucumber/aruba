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

  describe '#restore_env' do
    context 'when non-existing variable' do
      before :each do
        ENV.delete 'LONG_LONG_ENV_VARIABLE'
      end

      context 'when set single' do
        before :each do
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '1'
          @aruba.restore_env
        end

        it { expect(ENV).not_to be_key 'LONG_LONG_ENV_VARIABLE' }
      end

      context 'when set multiple times' do
        before :each do
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '1'
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '2'
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '3'
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
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '1'
          @aruba.restore_env
        end

        it { expect(ENV['LONG_LONG_ENV_VARIABLE']).to eq '0' }
      end

      context 'when set multiple times' do
        before :each do
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '1'
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '2'
          @aruba.set_env 'LONG_LONG_ENV_VARIABLE', '3'
          @aruba.restore_env
        end

        it { expect(ENV['LONG_LONG_ENV_VARIABLE']).to eq '0' }
      end
    end
  end

  describe "#restore_env" do
    after(:each) { @aruba.all_commands.each(&:stop) }
    it "restores environment variable" do
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.restore_env
      @aruba.run "env"
      expect(@aruba.all_output).not_to include("LONG_LONG_ENV_VARIABLE")
    end
    it "restores environment variable that has been set multiple times" do
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'true'
      @aruba.set_env 'LONG_LONG_ENV_VARIABLE', 'false'
      @aruba.restore_env
      @aruba.run "env"
      expect(@aruba.all_output).not_to include("LONG_LONG_ENV_VARIABLE")
    end
  end
end
