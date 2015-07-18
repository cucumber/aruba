require 'delegate'

module Aruba
  class FileSize
    include Comparable

    private

    attr_reader :bytes, :divisor

    public

    def initialize(bytes)
      @bytes   = bytes
      @divisor = 1024
    end

    def to_byte
      bytes
    end
    alias_method :to_i, :to_byte

    def to_f
      to_i.to_f
    end

    def to_s
      to_i.to_s
    end
    alias_method :inspect, :to_s

    def coerce(other)
      [bytes, other]
    end

    def to_kibi_byte
      to_byte.to_f / divisor
    end

    def to_mebi_byte
      to_kibi_byte.to_f / divisor
    end

    def to_gibi_byte
      to_mebi_byte.to_f / divisor
    end

    def <=>(other)
      to_i <=> other.to_i
    end
  end
end
