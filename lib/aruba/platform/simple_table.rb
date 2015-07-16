module Aruba
  module Platform
    class SimpleTable
      private

      attr_reader :hash

      public

      def initialize(hash)
        @hash = hash
      end

      def to_s
        name_size  = hash.keys.map(&:to_s).max_by(&:length).length
        value_size = hash.values.map(&:to_s).max_by(&:length).length

        if RUBY_VERSION < '2'
          rows = []

          hash.each do |k,v|
            rows << format('%s => %s', k.to_s + ' ' * (name_size - k.to_s.size), v + ' ' * (value_size - v.to_s.size))
          end

          rows
        else
          hash.each_with_object([]) do |(k,v), a|
            a << format('%s => %s', k.to_s + ' ' * (name_size - k.to_s.size), v + ' ' * (value_size - v.to_s.size))
          end
        end
      end
    end
  end
end
