# frozen_string_literal: true

require 'aruba/platform'

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
        Aruba.platform.relative_path? value
      rescue StandardError
        false
      end
    end
  end
end
