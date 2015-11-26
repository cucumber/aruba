require 'contracts'

# Aruba
module Aruba
  # Contracts
  module Contracts
    # Enum
    class Enum < ::Contracts::CallableClass
      private

      attr_reader :vals

      public

      # Create contract
      def initialize(*vals)
        @vals = vals
      end

      # Check if value is part of array
      def valid?(val)
        vals.include? val
      end
    end
  end
end
