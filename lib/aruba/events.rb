# frozen_string_literal: true

require 'cucumber/core/event'

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
    class BasicEvent < Cucumber::Core::Event.new(:entity); end

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
