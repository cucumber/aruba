require 'spec_helper'

RSpec.describe Aruba::ApiBuilder do

  describe '#gen' do
    subject(:builder) { described_class.new }
    let(:platform) { double('Platform') }

    context 'when on windows' do
      context 'and on supported platform' do
        before :each do
          allow(platform).to receive(:is).and_return(:windows)
        end

        let(:platform_klass) { class_double('FindMyNewApiWindows') }

        before :each do
          allow(platform_klass).to receive(:call) do |*args|
            'Hello Windows'
          end
        end

        let(:api_action) do
          builder.gen(
            "FindMyNewApi",
            windows: platform_klass
          )
        end

        it { expect(api_action.new(current_platform: platform).call).to eq('Hello Windows') }
      end
    end

    context 'when on unix' do
      context 'and supported platform' do
        before :each do
          allow(platform).to receive(:is).and_return(:unix)
        end

        let(:platform_klass) { class_double('FindMyNewApiUnix') }

        before :each do
          allow(platform_klass).to receive(:call) do |*args|
            'Hello Unix'
          end
        end

        let(:api_action) do
          builder.gen(
            "FindMyNewApi",
            unix: platform_klass
          )
        end

        it { expect(api_action.new(current_platform: platform).call).to eq('Hello Unix') }
      end
    end

    context 'when unsupported platform' do
      before :each do
        allow(platform).to receive(:is).and_return(:unix)
      end

      let(:api_action) do
        builder.gen("FindMyNewApi", {})
      end

      it { expect{ api_action.new(current_platform: platform).call }.to raise_error(PlatformNotSupportedError) }
    end
  end
end
