require 'aruba/file_size'

module Aruba
  module Platforms
    class DiskUsageCalculator
      def call(blocks, block_size)
        Aruba::FileSize.new(blocks * block_size)
      end
    end
  end
end
