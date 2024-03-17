require "spec_helper"

RSpec.describe Aruba::Command do
  let(:command) do
    described_class.new(
      "exit 0",
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

  let(:event_bus) { instance_double(Aruba::EventBus) }
  let(:exit_timeout) { 0.01 }
  let(:io_wait_timeout) { 0.01 }
  let(:working_directory) { File.expand_path(".") }
  let(:environment) { ENV.to_hash }
  let(:main_class) { nil }
  let(:stop_signal) { nil }
  let(:startup_wait_time) { 0.01 }

  describe "#start" do
    before do
      allow(event_bus).to receive(:notify).with(Aruba::Events::CommandStarted)
      command.start
    end

    it "leaves the command in the started state" do
      expect(command).to be_started
    end
  end

  describe "#stop" do
    before do
      allow(event_bus).to receive(:notify).with(Aruba::Events::CommandStarted)
      allow(event_bus).to receive(:notify).with(Aruba::Events::CommandStopped)
      command.start
    end

    it "stops the command" do
      command.stop
      expect(command).to be_stopped
    end

    it "notifies the event bus" do
      command.stop
      expect(event_bus).to have_received(:notify).with(Aruba::Events::CommandStopped).once
    end

    it "notifies the event bus only once per run" do
      command.stop
      command.stop
      expect(event_bus).to have_received(:notify).with(Aruba::Events::CommandStopped).once
    end

    it "prevents #terminate from notifying the event bus" do
      command.stop
      command.terminate
      expect(event_bus).to have_received(:notify).with(Aruba::Events::CommandStopped).once
    end
  end

  describe "#terminate" do
    before do
      allow(event_bus).to receive(:notify).with(Aruba::Events::CommandStarted)
      allow(event_bus).to receive(:notify).with(Aruba::Events::CommandStopped)
      command.start
    end

    it "stops the command" do
      command.terminate
      expect(command).to be_stopped
    end

    it "notifies the event bus" do
      command.terminate
      expect(event_bus).to have_received(:notify).with(Aruba::Events::CommandStopped).once
    end

    it "notifies the event bus only once per run" do
      command.terminate
      command.terminate
      expect(event_bus).to have_received(:notify).with(Aruba::Events::CommandStopped).once
    end

    it "prevents #stop from notifying the event bus" do
      command.terminate
      command.stop
      expect(event_bus).to have_received(:notify).with(Aruba::Events::CommandStopped).once
    end
  end
end
