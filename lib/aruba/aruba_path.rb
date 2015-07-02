require 'pathname'

module Aruba
  class ArubaPath < SimpleDelegator
    def initialize(path)
      if path.is_a? Array
        __setobj__ Pathname.new(File.join(*path))
      else
        __setobj__ Pathname.new(path)
      end
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
      __setobj__(__getobj__ + p)
    end
    alias_method :<<, :push

    # Remove last component of path
    #
    # @example
    #   path = ArubaPath.new 'path/to/dir.d'
    #   path.pop
    #   puts path
    #   # => path/to
    def pop
      dirs = __getobj__.each_filename.to_a
      dirs.pop

      __setobj__ Pathname.new(File.join(*dirs))
    end

    # Return string at index
    #
    # @param [Integer, Range] index
    def [](index)
      to_s[index]
    end
  end
end
