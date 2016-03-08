require 'delegate'

# Aruba
module Aruba
  # File Size
  class FileSize
    include Comparable

    private

    attr_reader :bytes, :divisor

    public

    # Create file size object
    def initialize(bytes)
      @bytes   = bytes
      @divisor = 1024
    end

    # Convert to bytes
    def to_byte
      bytes
    end
    alias to_i to_byte

    # Convert to float
    def to_f
      to_i.to_f
    end

    # Convert to string
    def to_s
      to_i.to_s
    end
    alias inspect to_s

    # Move to other
    def coerce(other)
      [bytes, other]
    end

    # Convert to kibi byte
    def to_kibi_byte
      to_byte.to_f / divisor
    end

    # Convert to mebi byte
    def to_mebi_byte
      to_kibi_byte.to_f / divisor
    end

    # Convert to gibi byte
    def to_gibi_byte
      to_mebi_byte.to_f / divisor
    end

    # Compare size with other size
    def <=>(other)
      to_i <=> other.to_i
    end
  end
end
