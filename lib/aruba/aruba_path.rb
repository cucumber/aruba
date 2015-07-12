require 'pathname'
require 'delegate'

module Aruba
  class ArubaPath < Delegator
    def initialize(path)
      obj = [path.to_s].flatten

      super obj

      @delegate_sd_obj = obj
    end

    def __getobj__
      ::Pathname.new(::File.join(*@delegate_sd_obj))
    end

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
    alias_method :<<, :push

    # Remove last component of path
    #
    # @example
    #   path = ArubaPath.new 'path/to/dir.d'
    #   path.pop
    #   puts path
    #   # => path/to
    def pop
      @delegate_sd_obj.pop
    end

    if RUBY_VERSION < '1.9'
      def to_s
        __getobj__.to_s
      end

      def relative?
        !(%r{\A/} === to_s)
      end

      def absolute?
        (%r{\A/} === to_s)
      end
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
      if RUBY_VERSION < '1.9'
        to_s.chars.to_a[index].to_a.join('')
      else
        to_s[index]
      end
    end
  end
end
