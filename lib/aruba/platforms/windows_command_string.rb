# frozen_string_literal: true

# Aruba
module Aruba
  # Platforms
  module Platforms
    # This is a command which should be run
    #
    # @private
    class WindowsCommandString
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
