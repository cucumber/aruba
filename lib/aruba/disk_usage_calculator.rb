module Aruba
  class DiskUsageCalculator
    def calc(blocks, block_size)
      FileSize.new(blocks * block_size)
    end
  end
end
