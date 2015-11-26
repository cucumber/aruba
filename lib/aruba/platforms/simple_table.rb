# Aruba
module Aruba
  # Platforms
  module Platforms
    # Generate simple table
    class SimpleTable
      private

      attr_reader :hash

      public

      # Create
      #
      # @param [Hash] hash
      #   Input
      def initialize(hash)
        @hash = hash
      end

      # Generate table
      #
      # @return [String]
      #   The table
      def to_s
        longest_key = hash.keys.map(&:to_s).max_by(&:length)
        return [] if longest_key.nil?

        name_size  = longest_key.length

        if RUBY_VERSION < '2'
          rows = []

          hash.each do |k,v|
            rows << format("# %-#{name_size}s => %s", k, v)
          end

          rows.sort
        else
          hash.each_with_object([]) do |(k,v), a|
            a << format("# %-#{name_size}s => %s", k, v)
          end.sort
        end
      end
    end
  end
end
