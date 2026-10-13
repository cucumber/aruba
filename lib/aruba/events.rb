# frozen_string_literal: true

require 'cucumber/core/event'

# Aruba
module Aruba
  # Events
  module Events
    # cucumber-core version 19 and up
    if defined? Cucumber::Core::Event::Base
      # @private
      class BasicEvent < Cucumber::Core::Event::Base
        attr_reader :entity

        def initialize(entity)
          @entity = entity
          super()
        end
      end
    else
      # @private
      class BasicEvent < Cucumber::Core::Event.new(:entity); end
    end

    # Command was stopped
    class CommandStopped < BasicEvent
      def self.event_id
        :command_stopped
      end
    end

    # Command was started
    class CommandStarted < BasicEvent
      def self.event_id
        :command_started
      end
    end

    # An environment variable was changed
    class ChangedEnvironmentVariable < BasicEvent
      def self.event_id
        :changed_environment_variable
      end
    end

    # An environment variable was added
    class AddedEnvironmentVariable < BasicEvent
      def self.event_id
        :added_environment_variable
      end
    end

    # An environment variable was deleted
    class DeletedEnvironmentVariable < BasicEvent
      def self.event_id
        :deleted_environment_variable
      end
    end

    # The working directory has changed
    class ChangedWorkingDirectory < BasicEvent
      def self.event_id
        :changed_working_directory
      end
    end

    # The configuration was changed
    class ChangedConfiguration < BasicEvent
      def self.event_id
        :changed_configuration
      end
    end

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
