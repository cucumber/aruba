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
  class NoCommandHasBeenStartedError < StandardError; end

  # Raised if one tries to access last command stopped, but no command
  # has been stopped
  class NoCommandHasBeenStoppedError < StandardError; end
end
