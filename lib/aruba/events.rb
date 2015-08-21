require 'aruba/events/basic_event'

module Aruba
  module Events
    class CommandStopped < BasicEvent; end
    class CommandStarted < BasicEvent; end
    class ChangedEnvironmentVariable < BasicEvent; end
    class AddedEnvironmentVariable < BasicEvent; end
    class DeletedEnvironmentVariable < BasicEvent; end
    class ChangedWorkingDirectory < BasicEvent; end
    class ChangedConfiguration < BasicEvent; end
  end
end
