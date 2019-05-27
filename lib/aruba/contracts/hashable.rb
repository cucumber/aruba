# Aruba
module Aruba
  # Contracts
  module Contracts
    # Is value hashable
    class Hashable
      # Check that the object can be converted to a hash
      #
      # @param [Object] object
      #   The object to be checked
      def self.to_h(object)
        if object.respond_to?(:to_h)
          object.to_h
        else
          warn 'Value cannot be cast to hash. Returning original object'
          object
        end
      end
    end
  end
end
