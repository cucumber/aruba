module Aruba
  class BasicConfiguration
    # A configuration option
    class Option
      attr_accessor :name
      attr_writer :value

      def initialize(name:, value:)
        @name  = name
        @value = value
      end

      def value
        Marshal.load(Marshal.dump(@value))
      end

      def deep_dup
        Marshal.load(Marshal.dump(self))
      end

      def ==(other)
        name == other.name && value == other.value
      end
    end
  end
end
