require 'delegate'

# Aruba
module Aruba
  # Platforms
  module Platforms
    # This is a command which should be run
    #
    # This adds `cmd.exec` in front of commmand
    #
    # @private
    class WindowsCommandString < SimpleDelegator
      def initialize(cmd)
        __setobj__ format('%s /c "%s"', Aruba.platform.which('cmd.exe'), cmd)
      end

      # Convert to array
      def to_a
        Shellwords.split __getobj__
      end
    end
  end
end
