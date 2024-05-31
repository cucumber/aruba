# frozen_string_literal: true

require "aruba/errors"

# Event notification library
module Aruba
  # EventBus
  class EventBus
    # Resolve name to Event name
    class NameResolver
      # @private
      # Helpers for Resolvers
      module ResolveHelpers
        def camel_case(underscored_name)
          underscored_name.to_s.split("_").map { |word| word.upcase[0] + word[1..] }.join
        end

        # Thanks ActiveSupport
        # (Only needed to support Ruby 1.9.3 and JRuby)
        def constantize(camel_cased_word)
          names = camel_cased_word.split("::")

          # Trigger a built-in NameError exception including the ill-formed
          # constant in the message.
          Object.const_get(camel_cased_word) if names.empty?

          # Remove the first blank element in case of '::ClassName' notation.
          names.shift if names.size > 1 && names.first.empty?

          names.inject(Object) do |constant, name|
            if constant == Object
              constant.const_get(name)
            else
              candidate = constant.const_get(name)

              next candidate if constant.const_defined?(name, false)

              next candidate unless Object.const_defined?(name)

              # Go down the ancestors to check if it is owned directly. The check
              # stops when we reach Object or the end of ancestors tree.
              constant = constant.ancestors.inject do |const, ancestor|
                break const    if ancestor == Object
                break ancestor if ancestor.const_defined?(name, false)

                const
              end

              # owner is in Object, so raise
              constant.const_get(name, false)
            end
          end
        end
      end

      # @private
      # Convert a symbol in to an event class
      class SymbolResolver
        include ResolveHelpers

        class << self
          def match?(event_id)
            event_id.is_a? Symbol
          end

          # Which types are supported
          def supports
            [Symbol]
          end
        end

        def transform(default_namespace, event_id)
          constantize("#{default_namespace}::#{camel_case(event_id)}")
        end
      end

      # @private
      # Default failing resolver
      #
      # This comes into play if the user passes an invalid event type
      class FailingResolver
        class << self
          def match?(event_id)
            raise ArgumentError,
                  %(Input type "#{event_id.class}" of event_id "#{event_id}" is invalid)
          end

          def supports
            []
          end
        end
      end

      protected

      attr_reader :resolvers, :default_namespace

      public

      def initialize(default_namespace)
        @default_namespace = default_namespace

        @resolvers = []
        @resolvers << SymbolResolver
        @resolvers << FailingResolver
      end

      def transform(event_id)
        resolvers.find { |r| r.match? event_id }.new.transform(default_namespace, event_id)
      rescue StandardError => e
        types = @resolvers.map(&:supports).flatten.join(", ")
        message = "Transforming \"#{event_id}\" into an event class failed." \
                  " Supported types are: #{types}. #{e.message}."
        raise EventNameResolveError, message, cause: e
      end
    end
  end
end
