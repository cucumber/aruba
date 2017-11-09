require 'pathname'
require 'delegate'

require 'aruba/file_size'

# Aruba
module Aruba
  # Pathname for aruba files and directories
  #
  # @private
  class ArubaPath < Delegator
    def initialize(path)
      obj = [path.to_s].flatten

      super obj

      @delegate_sd_obj = obj
    end

    # Get path
    def __getobj__
      ::Pathname.new(::File.join(*@delegate_sd_obj))
    end

    # Set path
    def __setobj__(obj)
      @delegate_sd_obj = [obj.to_s].flatten
    end

    # Add directory/file to path
    #
    # @param [String] p
    #   The path to be added
    #
    # @example
    #   path = ArubaPath.new 'path/to/dir.d'
    #   path << 'subdir.d
    #   # or path.push 'subdir.d
    #   puts path
    #   # => path/to/dir.d/subdir.d
    def push(p)
      @delegate_sd_obj << p
    end
    alias << push

    # Remove last component of path
    #
    # @example
    #   path = ArubaPath.new 'path/to/dir.d'
    #   path.pop
    #   puts path # => path/to
    def pop
      @delegate_sd_obj.pop
    end

    # How many parts has the file name
    #
    # @return [Integer]
    #   The count of file name parts
    #
    # @example
    #   path = ArubaPath.new('path/to/file.txt')
    #   path.depth # => 3
    #
    def depth
      __getobj__.each_filename.to_a.size
    end

    # Path ends with string
    #
    # @param [String] string
    #   The string to check
    def end_with?(string)
      to_s.end_with? string
    end

    # Path starts with string
    #
    # @param [String] string
    #   The string to check
    def start_with?(string)
      to_s.start_with? string
    end

    # Return string at index
    #
    # @param [Integer, Range] index
    def [](index)
      to_s[index]
    end

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
    def minimum_disk_space_used
      # TODO: replace Aruba.config.physical_block_size
      # with something like Aruba.config.fs_allocation_unit
      dev_bsize = Aruba.config.physical_block_size

      stat = File::Stat.new(to_s)

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
