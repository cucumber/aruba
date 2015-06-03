module Aruba
  # Standard error
  class Error < StandardError; end

  # An error because a user of the API did something wrong
  class UserError < StandardError; end

  # Raised on launch error
  class LaunchError < Error; end

  # Raised if one tries to use an unknown configuration option
  class UnknownOptionError < ArgumentError; end
end
