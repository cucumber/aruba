module Aruba
  class BasicConfiguration
    # A configuration option
    class Option
      attr_accessor :name, :value
      attr_reader :default_value

      def initialize(name: nil, value: nil)
        fail ArgumentError, '"name" is required' if name.nil?
        fail ArgumentError, '"value" is required' if value.nil?

        @name          = name
        @value         = value
        @default_value = value
      end

      def ==(other)
        name == other.name && value == other.value
      end
    end
  end
end
