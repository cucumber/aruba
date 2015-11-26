require 'aruba/matchers/base/base_matcher'

# Aruba
module Aruba
  # Matchers
  module Matchers
    # @api private
    # Provides the implementation for `include_an_object`.
    # Not intended to be instantiated directly.
    class IncludeAnObject < BaseMatcher
      protected

      # @private
      attr_reader :matcher, :failed_objects
      # @private
      attr_accessor :any_succeeded_object

      public

      def initialize(matcher)
        @matcher              = matcher
        @failed_objects       = {}
        @any_succeeded_object = false
      end

      # @api private
      # @return [String]
      def failure_message
        unless iterable?
          return "#{improve_hash_formatting(super)}, but was not iterable"
        end

        all_messages = [improve_hash_formatting(super)]
        failed_objects.each do |index, matcher_failure_message|
          all_messages << failure_message_for_item(index, matcher_failure_message)
        end
        all_messages.join("\n\n")
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

        any_succeeded_object == false
      end

      private

      def match(expected, actual)
        @actual   = actual
        @expected = expected

        return false unless iterable?

        index_objects

        any_succeeded_object == true
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
            self.any_succeeded_object = true
            break
          else
            failed_objects[index] = cloned_matcher.failure_message
          end
        end
      end

      def failure_message_for_item(index, failure_message)
        failure_message = indent_multiline_message(add_new_line_if_needed(failure_message))
        indent_multiline_message("object at index #{index} failed to match:#{failure_message}")
      end

      def add_new_line_if_needed(message)
        message.start_with?("\n") ? message : "\n#{message}"
      end

      def indent_multiline_message(message)
        message = message.sub(/\n+\z/, '')
        message.lines.map do |line|
          line =~ /\S/ ? '   ' + line : line
        end.join
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
    #   expect([1, 4, 5]).to include_an_object be_odd
    #
    # @note You can also use this with compound matchers as well.
    #
    # @example
    #   expect([1, 4, 'a']).to include_an_object( be_odd.and be_an(Integer) )
    def include_an_object(expected)
      ::Aruba::Matchers::IncludeAnObject.new(expected)
    end
  end
end
