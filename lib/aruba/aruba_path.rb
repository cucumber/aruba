require 'pathname'
require 'delegate'

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

    # Return string at index
    #
    # @param [Integer, Range] index
    def [](index)
      to_s[index]
    end
  end
end
