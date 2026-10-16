# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Aruba::Events do
  describe '.registry' do
    it 'keys each event by its underscored class name' do
      expect(described_class.registry).to eq(
        command_started: Aruba::Events::CommandStarted,
        command_stopped: Aruba::Events::CommandStopped,
        added_environment_variable: Aruba::Events::AddedEnvironmentVariable,
        changed_environment_variable: Aruba::Events::ChangedEnvironmentVariable,
        deleted_environment_variable: Aruba::Events::DeletedEnvironmentVariable,
        changed_working_directory: Aruba::Events::ChangedWorkingDirectory,
        changed_configuration: Aruba::Events::ChangedConfiguration
      )
    end
  end

  describe Aruba::Events::BasicEvent do
    let(:event) { Aruba::Events::ChangedWorkingDirectory.new(old: 'tmp', new: 'tmp/aruba') }

    it 'exposes its entity' do
      expect(event.entity).to eq(old: 'tmp', new: 'tmp/aruba')
    end

    it 'knows its event id' do
      expect(event.event_id).to eq :changed_working_directory
    end

    it 'can be broadcast on an event bus built from the registry' do
      bus = Aruba::EventBus.new(Aruba::Events.registry)
      received = []
      bus.register(:changed_working_directory) { |payload| received << payload }

      bus.notify event

      expect(received).to eq [event]
    end
  end
end
