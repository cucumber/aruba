# Aruba
module Aruba
  # Basic Configuration
  #
  class BasicConfiguration
    # A configuration option
    #
    # @private
    class Option
      attr_accessor :name, :value
      attr_reader :default_value

      # Create option
      def initialize(opts = {})
        name = opts[:name]
        value = opts[:value]

        fail ArgumentError, '"name" is required' unless opts.key? :name
        fail ArgumentError, '"value" is required' unless opts.key? :value

        @name          = name
        @value         = value
        @default_value = value
      end

      # Compare option
      def ==(other)
        name == other.name && value == other.value
      end
    end
  end
end
