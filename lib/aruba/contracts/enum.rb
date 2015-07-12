require 'contracts'

module Aruba
  module Contracts
    class Enum < ::Contracts::CallableClass
      private

      attr_reader :vals

      public

      def initialize(*vals)
        @vals = vals
      end

      def valid?(val)
        vals.include? val
      end
    end
  end
end
