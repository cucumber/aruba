require 'aruba/matchers/base/object_formatter'

# Aruba
module Aruba
  # Matchers
  module Matchers
    # Base Matcher
    class BaseMatcher
      # @api private
      # Used to detect when no arg is passed to `initialize`.
      # `nil` cannot be used because it's a valid value to pass.
      UNDEFINED = Object.new.freeze

      # @private
      attr_reader :actual, :expected, :rescued_exception

      def initialize(expected = UNDEFINED)
        @expected = expected unless UNDEFINED.equal?(expected)
      end

      # @api private
      # Indicates if the match is successful. Delegates to `match`, which
      # should be defined on a subclass. Takes care of consistently
      # initializing the `actual` attribute.
      def matches?(actual)
        @actual = actual
        match(expected, actual)
      end

      def iterable?
        @actual.respond_to?(:each_with_index)
      end

      # @private
      module HashFormatting
        # `{ :a => 5, :b => 2 }.inspect` produces:
        #
        #     {:a=>5, :b=>2}
        #
        # ...but it looks much better as:
        #
        #     {:a => 5, :b => 2}
        #
        # This is idempotent and safe to run on a string multiple times.
        def improve_hash_formatting(inspect_string)
          inspect_string.gsub(/(\S)=>(\S)/, '\1 => \2')
        end
        module_function :improve_hash_formatting
      end

      include HashFormatting

      # @api private
      # Provides default implementations of failure messages, based on the `description`.
      module DefaultFailureMessages
        # @api private
        # Provides a good generic failure message. Based on `description`.
        # When subclassing, if you are not satisfied with this failure message
        # you often only need to override `description`.
        # @return [String]
        def failure_message
          "expected #{description_of @actual} to #{description}"
        end

        # @api private
        # Provides a good generic negative failure message. Based on `description`.
        # When subclassing, if you are not satisfied with this failure message
        # you often only need to override `description`.
        # @return [String]
        def failure_message_when_negated
          "expected #{description_of @actual} not to #{description}"
        end

        # @private
        # rubocop:disable Style/PredicateName
        def self.has_default_failure_messages?(matcher)
          matcher.method(:failure_message).owner == self &&
            matcher.method(:failure_message_when_negated).owner == self
        rescue NameError
          false
        end
        # rubocop:enable Style/PredicateName
      end

      include DefaultFailureMessages

      # Returns the description of the given object in a way that is
      # aware of composed matchers. If the object is a matcher with
      # a `description` method, returns the description; otherwise
      # returns `object.inspect`.
      def description_of(object)
        Aruba::Matchers::ObjectFormatter.format(object)
      end
    end
  end
end
