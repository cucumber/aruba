module Aruba
  module Platform
    class DetermineDiskUsage
      def use(paths)
        size = paths.map do |p|
          DiskUsageCalculator.new.calc(
            p.blocks,
            aruba.config.physical_block_size
          )
        end.inject(0, &:+)

        FileSize.new(size)
      end
    end
  end
end
