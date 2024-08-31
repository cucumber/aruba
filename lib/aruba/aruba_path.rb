# frozen_string_literal: true

require 'pathname'

# Aruba
module Aruba
  # Pathname for aruba files and directories
  #
  # @private
  class ArubaPath
    def initialize(path)
      @obj = [path.to_s].flatten
    end

    def to_str
      to_pathname.to_s
    end

    def to_s
      to_str
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
      @obj << p
    end
    alias << push

    # Remove last pushed component of path
    #
    # @example
    #   path = ArubaPath.new 'path/to'
    #   path.push 'dir'
    #   path.pop
    #   puts path # => path/to
    def pop
      @obj.pop
    end

    # Return string at index
    #
    # @param [Integer, Range] index
    def [](index)
      to_s[index]
    end

    private

    # Get path
    def to_pathname
      current_path = @obj.inject do |path, element|
        if element.start_with?('~') ||
           Aruba.platform.absolute_path?(element)
          element
        else
          File.join(path, element)
        end
      end
      ::Pathname.new(current_path)
    end
  end
end
