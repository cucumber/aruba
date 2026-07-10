# frozen_string_literal: true

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
      def initialize(name:, value:)
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
