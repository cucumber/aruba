require 'pathname'
require 'delegate'

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
      __setobj__(File.join(__getobj__, p))
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
      if RUBY_VERSION < '1.9'
        dirs = []
        __getobj__.each_filename { |f| dirs << f }
      else
        dirs = __getobj__.each_filename.to_a
      end

      dirs.pop

      __setobj__ Pathname.new(File.join(*dirs))
    end

    if RUBY_VERSION < '1.9'
      def to_s
        __getobj__.to_s
      end

      def relative?
        !(%r{\A/} === __getobj__)
      end

      def absolute?
        (%r{\A/} === __getobj__)
      end
    end

    # Return string at index
    #
    # @param [Integer, Range] index
    def [](index)
      if RUBY_VERSION < '1.9'
        to_s.chars.to_a[index].to_a.join('')
      else
        to_s[index]
      end
    end
  end
end
