# Aruba
module Aruba
  # Events
  module Events
    # Basic event
    #
    # This is not meant for direct use - BasicEvent.new - by users. It is inherited by normal events
    #
    # @private
    class BasicEvent
      attr_reader :entity

      def initialize(entity)
        @entity = entity
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
  end
end
