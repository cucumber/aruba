module Aruba
  module Platform
    class DetermineDiskUsage
      def use(*args)
        args = args.flatten

        physical_block_size = args.pop
        paths = args

        size = paths.flatten.map do |p|
          DiskUsageCalculator.new.calc(
            p.blocks,
            physical_block_size
          )
        end.inject(0, &:+)

        FileSize.new(size)
      end
    end
  end
end
