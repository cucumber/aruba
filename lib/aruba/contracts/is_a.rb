require 'contracts'

module Aruba
  module Contracts
    class IsA < ::Contracts::CallableClass
      private

      attr_reader :vals

      public

      def initialize(*vals)
        @vals = vals
      end

      def valid?(val)
        vals.any? { |v| val.is_a? v }
      end
    end
  end
end
