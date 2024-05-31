# frozen_string_literal: true

require "spec_helper"

describe Aruba::EventBus do
  let(:bus) { described_class.new(name_resolver) }

  let(:name_resolver) do
    { test_event: Events::TestEvent,
      another_test_event: Events::AnotherTestEvent }
  end

  let(:event_klass) { Events::TestEvent }
  let(:event_instance) { event_klass.new }

  let(:another_event_klass) { Events::AnotherTestEvent }
  let(:another_event_instance) { another_event_klass.new }

  before do
    stub_const("Events::TestEvent", Class.new)
    stub_const("Events::AnotherTestEvent", Class.new)
    stub_const("MyHandler", Class.new { def call(*); end })
    stub_const("MyMalformedHandler", Class.new)
  end

  describe "#notify" do
    before do
      bus.register(:test_event) do |event|
        @received_payload = event
      end
    end

    context "when subscribed to the event" do
      it "calls the block with an instance of the event passed as payload" do
        bus.notify event_instance
        expect(@received_payload).to eq(event_instance)
      end
    end

    context "when not subscribed to the event" do
      it "does not call the block" do
        bus.notify another_event_instance
        expect(@received_payload).to be_nil
      end
    end

    context "when event is not an event instance" do
      it "raises an error" do
        expect { bus.notify event_klass }.to raise_error ArgumentError
      end
    end
  end

  describe "#register" do
    context "when registering an event multiple times" do
      let(:received_events) { [] }

      before do
        bus.register(:test_event) do |event|
          received_events << event
        end
        bus.register(:test_event) do |event|
          received_events << event
        end
      end

      it "keeps all registrations" do
        bus.notify event_instance

        expect(received_events).to eq [event_instance, event_instance]
      end
    end

    context "when event id is a symbol" do
      let(:received_payload) { [] }

      before do
        bus.register(:test_event) do |event|
          received_payload << event
        end

        bus.notify event_instance
      end

      it { expect(received_payload).to include event_instance }
    end

    context "when multiple event ids are given" do
      let(:received_payload) { [] }

      before do
        bus.register [:test_event, :another_test_event] do |event|
          received_payload << event
        end
      end

      it "handles all passed in events" do
        bus.notify event_instance
        bus.notify another_event_instance
        expect(received_payload).to eq [event_instance, another_event_instance]
      end
    end

    context "when valid custom handler" do
      before do
        bus.register(:test_event, MyHandler.new)
      end

      it { expect { bus.notify event_instance }.not_to raise_error }
    end

    context "when no handler is given" do
      it "raises an ArgumentError" do
        expect { bus.register(event_klass) }.to raise_error ArgumentError
      end
    end
  end
end
