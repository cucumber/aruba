require 'spec_helper'

RSpec.describe Aruba::Command do
  subject do
    described_class.new(
      'true',
      event_bus: event_bus,
      exit_timeout: exit_timeout,
      io_wait_timeout: io_wait_timeout,
      working_directory: working_directory,
      environment: environment,
      main_class: main_class,
      stop_signal: stop_signal,
      startup_wait_time: startup_wait_time
    )
  end

  let(:event_bus) { instance_double('Aruba::EventBus') }
  let(:exit_timeout) { 1 }
  let(:io_wait_timeout) { 1 }
  let(:working_directory) { expand_path('.') }
  let(:environment) { ENV.to_hash }
  let(:main_class) { nil }
  let(:stop_signal) { nil }
  let(:startup_wait_time) { 1 }

  context '#started' do
    before :each do
      allow(event_bus).to receive(:notify) { |a| a.is_a?(Events::CommandStarted) }
    end

    before :each do
      subject.start
    end

    it { is_expected.to be_started }
  end

  context '#stopped' do
    before :each do
      allow(event_bus).to receive(:notify) { |a| a.is_a?(Events::CommandStarted) }
      allow(event_bus).to receive(:notify) { |a| a.is_a?(Events::CommandStopped) }
    end

    before :each do
      subject.start
      subject.stop
    end

    it { is_expected.to be_stopped }
  end

  context '#terminate' do
    before :each do
      allow(event_bus).to receive(:notify) { |a| a.is_a?(Events::CommandStarted) }
      allow(event_bus).to receive(:notify) { |a| a.is_a?(Events::CommandStopped) }
    end

    before :each do
      subject.start
      subject.terminate
    end

    it { is_expected.to be_stopped }
  end
end
