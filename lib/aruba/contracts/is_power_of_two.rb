# frozen_string_literal: true

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
        value.positive? && value.nobits?(value - 1)
      rescue StandardError
        false
      end
    end
  end
end
