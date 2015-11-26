require 'aruba/file_size'

# Aruba
module Aruba
  # Platforms
  module Platforms
    # Calculate disk usage
    class DiskUsageCalculator
      # Calc
      #
      # @param [Integer] blocks
      #   Count of blocks
      # @param [Integer] block_size
      #   The size of a single block
      def call(blocks, block_size)
        Aruba::FileSize.new(blocks * block_size)
      end
    end
  end
end
