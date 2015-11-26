require 'aruba/aruba_path'

# Aruba
module Aruba
  # Contracts
  module Contracts
    # Check if path is absolute
    class AbsolutePath
      # Check
      #
      # @param [Object] value
      #   The value to be checked
      def self.valid?(value)
        ArubaPath.new(value).absolute?
      rescue
        false
      end
    end
  end
end
