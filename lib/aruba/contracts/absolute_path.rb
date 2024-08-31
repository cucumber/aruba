# frozen_string_literal: true

require 'aruba/platform'

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
        Aruba.platform.absolute_path? value
      rescue StandardError
        false
      end
    end
  end
end
