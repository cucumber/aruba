# frozen_string_literal: true

# Aruba
module Aruba
  # Platforms
  module Platforms
    # Generate simple table
    class SimpleTable
      private

      attr_reader :hash, :opts

      public

      # Create
      #
      # @param [Hash] hash
      #   Input
      def initialize(hash, opts)
        @hash = hash
        @opts = {
          sort: true
        }.merge opts
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

        if opts[:sort] == true
          rows.sort.join("\n")
        else
          rows.join("\n")
        end
      end
    end
  end
end
