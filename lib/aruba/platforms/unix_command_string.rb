require 'delegate'
require 'shellwords'

# Aruba
module Aruba
  # Platforms
  module Platforms
    # This is a command which should be run
    class UnixCommandString < SimpleDelegator
      def initialize(cmd)
        __setobj__ cmd
      end

      # Convert to array
      def to_a
        [__getobj__]
      end
    end
  end
end
