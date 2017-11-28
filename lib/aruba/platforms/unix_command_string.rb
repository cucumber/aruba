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

      if RUBY_VERSION < '1.9'
        def to_s
          __getobj__.to_s
        end
        alias inspect to_s
      end
    end
  end
end
