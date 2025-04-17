# frozen_string_literal: true

require 'delegate'
require 'shellwords'

# Aruba
module Aruba
  # Platforms
  module Platforms
    # This is a command which should be run
    #
    # @private
    class UnixCommandString
      def initialize(command, *arguments)
        @command = command
        @arguments = arguments
      end

      # Convert to array
      def to_a
        [@command, *@arguments]
      end
    end
  end
end
