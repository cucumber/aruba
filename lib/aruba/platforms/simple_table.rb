# frozen_string_literal: true

# Aruba
module Aruba
  # Platforms
  module Platforms
    # Generate simple table
    class SimpleTable
      # Create
      #
      # @param [Hash] hash
      #   Input
      def initialize(hash, sort: true)
        @hash = hash
        @sort = sort
      end

      # Generate table
      #
      # @return [String]
      #   The table
      def to_s
        longest_key = hash.keys.map(&:to_s).max_by(&:length)
        return '' if longest_key.nil?

        name_size = longest_key.length

        rows = hash.map do |k, v|
          format('# %-*s => %s', name_size, k, v)
        end

        if sort
          rows.sort.join("\n")
        else
          rows.join("\n")
        end
      end

      private

      attr_reader :hash, :sort
    end
  end
end
