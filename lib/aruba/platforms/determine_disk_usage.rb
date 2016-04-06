require 'aruba/platforms/disk_usage_calculator'

# Aruba
module Aruba
  # Platforms
  module Platforms
    # Determinate disk usage
    #
    # @private
    class DetermineDiskUsage
      def call(*args)
        args = args.flatten

        deprecated_block_size = args.pop
        paths = args

        size = paths.flatten.map do |p|
          # TODO: replace the `call` methods signature so that you can use just
          # p.minimum_disk_space_used
          #
          # (Same result, since the values are multiplied, so
          # deprecated_block_size is canceled out
          DiskUsageCalculator.new.call(
            (p.minimum_disk_space_used / deprecated_block_size),
            deprecated_block_size
          )
        end.inject(0, &:+)

        FileSize.new(size)
      end
    end
  end
end
