require 'aruba/aruba_path'

# Aruba
module Aruba
  # Contracts
  module Contracts
    # Is value power of two
    class IsPowerOfTwo
      # Check value
      #
      # @param [Integer] value
      #   The value to be checked
      def self.valid?(value)
        # explanation for algorithm can be found here:
        # http://www.exploringbinary.com/ten-ways-to-check-if-an-integer-is-a-power-of-two-in-c/
        value != 0 && (value & (value - 1)) == 0 ? true : false
      rescue
        false
      end
    end
  end
end
