require 'rspec/matchers/built_in/all'

module Aruba
  module Matchers
    # @api private
    # Provides the implementation for `all`.
    # Not intended to be instantiated directly.
    class IncludeAnObject < RSpec::Matchers::BuiltIn::All
      # @private
      attr_reader :matcher, :failed_objects, :succeeded_objects

      def initialize(matcher)
        @matcher           = matcher
        @failed_objects    = {}
        @succeeded_objects = {}
      end

      # @api private
      # @return [String]
      def description
        improve_hash_formatting "include an object #{description_of matcher}"
      end

      def does_not_match?(actual)
        @actual = actual

        return false unless iterable?

        index_objects

        succeeded_objects.empty?
      end

      private

      def match(expected, actual)
        @actual   = actual
        @expected = expected

        return false unless iterable?

        index_objects

        !succeeded_objects.empty?
      end

      def index_objects
        actual.each_with_index do |actual_item, index|
          cloned_matcher = matcher.clone
          begin
            matches = cloned_matcher.matches?(actual_item)
          rescue StandardError
            matches = nil
          end

          if matches
            succeeded_objects[index] = cloned_matcher.failure_message
            break
          else
            failed_objects[index] = cloned_matcher.failure_message
          end
        end
      end
    end
  end
end

module RSpec
  module Matchers
    # Passes if the provided matcher passes when checked against any
    # element of the collection.
    #
    # @example
    #   expect([1, 4, 5]).to any be_odd
    #
    # @note The negative form `not_to any` is not supported. Instead
    #   use `not_to include` or pass a negative form of a matcher
    #   as the argument (e.g. `all exclude(:foo)` - mind it's `all` here).
    #
    # @note You can also use this with compound matchers as well.
    #
    # @example
    #   expect([1, 4, 'a']).to any( be_odd.and be_an(Integer) )
    def include_an_object(expected)
      ::Aruba::Matchers::IncludeAnObject.new(expected)
    end
  end
end
