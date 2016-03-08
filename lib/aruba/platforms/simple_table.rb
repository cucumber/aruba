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
          :sort => true
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

        if RUBY_VERSION < '2'
          rows = []

          hash.each do |k,v|
            rows << format("# %-#{name_size}s => %s", k, v)
          end
        else
          rows = hash.each_with_object([]) do |(k,v), a|
            a << format("# %-#{name_size}s => %s", k, v)
          end
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
