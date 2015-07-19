require 'aruba/aruba_path'

module Aruba
  module Contracts
    class IsPowerOfTwo
      def self.valid?(x)
        # explanation for algorithm can be found here:
        # http://www.exploringbinary.com/ten-ways-to-check-if-an-integer-is-a-power-of-two-in-c/
        x != 0 && (x & (x - 1)) == 0 ? true : false
      rescue
        false
      end
    end
  end
end
