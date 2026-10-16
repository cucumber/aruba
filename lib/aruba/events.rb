# frozen_string_literal: true

# Aruba
module Aruba
  # Events
  module Events
    # Basic event
    #
    # This is not meant for direct use - BasicEvent.new - by users. It is
    # inherited by normal events
    #
    # @private
    class BasicEvent
      # @return [Symbol] the underscored class name, used as the key in the event registry
      def self.event_id
        name.split('::').last.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase.to_sym
      end

      attr_reader :entity

      def initialize(entity)
        @entity = entity
      end

      def event_id
        self.class.event_id
      end

      def to_h
        { entity: entity }
      end
    end

    # Command was stopped
    class CommandStopped < BasicEvent; end

    # Command was started
    class CommandStarted < BasicEvent; end

    # An environment variable was changed
    class ChangedEnvironmentVariable < BasicEvent; end

    # An environment variable was added
    class AddedEnvironmentVariable < BasicEvent; end

    # An environment variable was deleted
    class DeletedEnvironmentVariable < BasicEvent; end

    # The working directory has changed
    class ChangedWorkingDirectory < BasicEvent; end

    # The configuration was changed
    class ChangedConfiguration < BasicEvent; end

    def self.registry
      [CommandStarted,
       CommandStopped,
       AddedEnvironmentVariable,
       ChangedEnvironmentVariable,
       DeletedEnvironmentVariable,
       ChangedWorkingDirectory,
       ChangedConfiguration].to_h { |klass| [klass.event_id, klass] }
    end
  end
end
