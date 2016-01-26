module Aruba
  # Standard error
  class Error < StandardError; end

  # An error because a user of the API did something wrong
  class UserError < StandardError; end

  # Raised on launch error
  class LaunchError < Error; end

  # Raised if one tries to use an unknown configuration option
  class UnknownOptionError < ArgumentError; end

  # Raised if command already died
  class CommandAlreadyStoppedError < Error; end

  # Raised if one tries to access last command started, but no command
  # has been started
  class NoCommandHasBeenStartedError < Error; end

  # Raised if one tries to access last command stopped, but no command
  # has been stopped
  class NoCommandHasBeenStoppedError < Error; end

  # Raised if one looked for a command, but no matching was found
  class CommandNotFoundError < ArgumentError; end

  # Raised if command was already started, otherwise aruba forgets about the
  # previous pid and you've got hidden commands run
  class CommandAlreadyStartedError < Error; end

  # Raised if an event name cannot be resolved
  class EventNameResolveError < StandardError; end

  # Raised if given object is not an event
  class NoEventError < StandardError; end
end
