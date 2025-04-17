# frozen_string_literal: true

require 'aruba/file_size'

module Aruba
  module Platforms
    # Determinate disk usage
    #
    # @private
    class DetermineDiskUsage
      def call(paths)
        size = paths.flatten.sum { |path| minimum_disk_space_used path }

        FileSize.new(size)
      end

      private

      # TODO: Aruba.config.physical_block_size could be allowed to be nil
      # (So the unit size can be autodetected)

      # Report minimum disk space used
      #
      # This estimates the minimum bytes allocated by the path.
      #
      # E.g. a 1-byte text file on a typical EXT-3 filesystem takes up 4096 bytes
      # (could be more if it was truncated or less for sparse files).
      #
      # Both `File::Stat` and the `stat()` system call will report 8 `blocks`
      # (each "usually" represents 512 bytes). So 8 * 512 is exactly 4096 bytes.
      #
      # (The "magic" 512 bye implied makes the value of "blocks" so confusing).
      #
      # Currently Aruba allows you to set what's called the `physical_block_size`,
      # which is a bit misleading - it's the "512" value. So if you somehow have a
      # "filesystem unit size" of 8192 (instead of a typical 4KB), set the
      # `physical_block_size` to 1024 (yes, divide by 8: 8192/8 = 1024).
      #
      # Ideally, Aruba should provide e.g. `Aruba.config.fs_allocation_unit`
      # (with 4096 as the default), so you wouldn't have to "divide by 8".
      #
      # (typical_fs_unit / typical_dev_bsize = 4096 / 512 = 8)
      #
      #
      # @return [Integer]
      #   Total bytes allocate
      #
      # TODO: this is recommended over the above "blocks"
      def minimum_disk_space_used(path)
        # TODO: replace Aruba.config.physical_block_size
        # with something like Aruba.config.fs_allocation_unit
        dev_bsize = Aruba.config.physical_block_size

        stat = File::Stat.new(path.to_s)

        blocks = stat.blocks
        return (blocks * dev_bsize) if blocks

        typical_fs_unit = 4096
        typical_dev_bsize = 512 # google dev_bsize for more info

        block_multiplier = typical_fs_unit / typical_dev_bsize
        fs_unit_size = dev_bsize * block_multiplier
        fs_units = (stat.size + fs_unit_size - 1) / fs_unit_size
        fs_units = 1 if fs_units.zero?
        fs_units * fs_unit_size
      end
    end
  end
end
