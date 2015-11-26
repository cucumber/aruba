require 'aruba/aruba_path'

# Aruba
module Aruba
  # Contracts
  module Contracts
    # Is value relative path
    class RelativePath
      # Check
      #
      # @param [String] value
      #   The path to be checked
      def self.valid?(value)
        ArubaPath.new(value).relative?
      rescue
        false
      end
    end
  end
end
