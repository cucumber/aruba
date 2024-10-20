# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Aruba::Command do
  let(:event_bus) { instance_double(Aruba::EventBus) }
  let(:command) do
    described_class.new('true',
                        event_bus: event_bus,
                        startup_wait_time: 0.01, io_wait_timeout: 0.01, exit_timeout: 0.01,
                        working_directory: File.expand_path('.'),
                        environment: ENV.to_hash,
                        main_class: nil, stop_signal: nil)
  end

  describe '#start' do
    it 'leaves the command in the started state' do
      allow(event_bus).to receive(:notify).with(Aruba::Events::CommandStarted)
      command.start
      expect(command).to be_started
    end

    it 'notifies the event bus' do
      expect(event_bus).to receive(:notify).with(Aruba::Events::CommandStarted)
      command.start
    end
  end

  describe '#stop' do
    before do
      allow(event_bus).to receive(:notify).with(Aruba::Events::CommandStarted)
      command.start
    end

    it 'stops the command' do
      allow(event_bus).to receive(:notify).with(Aruba::Events::CommandStopped)
      command.stop
      expect(command).to be_stopped
    end

    it 'notifies the event bus' do
      expect(event_bus).to receive(:notify).with(Aruba::Events::CommandStopped).once
      command.stop
    end

    it 'notifies the event bus only once per run' do
      expect(event_bus).to receive(:notify).with(Aruba::Events::CommandStopped).once
      command.stop
      command.stop
    end

    it 'prevents #terminate from notifying the event bus' do
      expect(event_bus).to receive(:notify).with(Aruba::Events::CommandStopped).once
      command.stop
      command.terminate
    end
  end

  describe '#terminate' do
    before do
      allow(event_bus).to receive(:notify).with(Aruba::Events::CommandStarted)
      command.start
    end

    it 'stops the command' do
      allow(event_bus).to receive(:notify).with(Aruba::Events::CommandStopped)
      command.terminate
      expect(command).to be_stopped
    end

    it 'notifies the event bus' do
      expect(event_bus).to receive(:notify).with(Aruba::Events::CommandStopped).once
      command.terminate
    end

    it 'notifies the event bus only once per run' do
      expect(event_bus).to receive(:notify).with(Aruba::Events::CommandStopped).once
      command.terminate
      command.terminate
    end

    it 'prevents #stop from notifying the event bus' do
      expect(event_bus).to receive(:notify).with(Aruba::Events::CommandStopped).once
      command.terminate
      command.stop
    end
  end
end
