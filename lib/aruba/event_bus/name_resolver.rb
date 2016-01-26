require 'aruba/errors'

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
          if RUBY_VERSION < '1.9.3'
            underscored_name.to_s.split('_').map { |word| word.upcase.chars.to_a[0] + word.chars.to_a[1..-1].join }.join
          else
            underscored_name.to_s.split('_').map { |word| word.upcase[0] + word[1..-1] }.join
          end
        end

        # Thanks ActiveSupport
        # (Only needed to support Ruby 1.9.3 and JRuby)
        # rubocop:disable Metrics/CyclomaticComplexity
        # rubocop:disable Metrics/MethodLength
        def constantize(camel_cased_word)
          names = camel_cased_word.split('::')

          # Trigger a built-in NameError exception including the ill-formed constant in the message.
          Object.const_get(camel_cased_word) if names.empty?

          # Remove the first blank element in case of '::ClassName' notation.
          names.shift if names.size > 1 && names.first.empty?

          names.inject(Object) do |constant, name|
            if constant == Object
              constant.const_get(name)
            else
              candidate = constant.const_get(name)

              if RUBY_VERSION < '1.9.3'
                next candidate if constant.const_defined?(name)
              else
                next candidate if constant.const_defined?(name, false)
              end

              next candidate unless Object.const_defined?(name)

              # Go down the ancestors to check if it is owned directly. The check
              # stops when we reach Object or the end of ancestors tree.
              # rubocop:disable Style/EachWithObject
              constant = constant.ancestors.inject do |const, ancestor|
                break const    if ancestor == Object
                break ancestor if ancestor.const_defined?(name, false)
                const
              end
              # rubocop:enable Style/EachWithObject

              # owner is in Object, so raise
              constant.const_get(name, false)
            end
          end
        end
        # rubocop:enable Metrics/CyclomaticComplexity
        # rubocop:enable Metrics/MethodLength
      end

      # @private
      # Convert a class in to an event class
      class ClassResolver
        class << self
          def match?(event_id)
            event_id.is_a? Class
          end

          # Which types are supported
          def supports
            [Class]
          end
        end

        def transform(_, event_id)
          event_id
        end
      end

      # @private
      # Convert a string in to an event class
      class StringResolver
        include ResolveHelpers

        class << self
          def match?(event_id)
            event_id.is_a? String
          end

          # Which types are supported
          def supports
            [String]
          end
        end

        def transform(_, event_id)
          constantize(event_id)
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
            fail ArgumentError, %(Input type "#{event_id.class}" of event_id "#{event_id}" is invalid)
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
        @resolvers << ClassResolver
        @resolvers << StringResolver
        @resolvers << SymbolResolver
        @resolvers << FailingResolver
      end

      def transform(event_id)
        resolvers.find { |r| r.match? event_id }.new.transform(default_namespace, event_id)
      rescue => e
        # rubocop:disable Metrics/LineLength
        raise EventNameResolveError, %(Transforming "#{event_id}" into an event class failed. Supported types are: #{@resolvers.map(&:supports).flatten.join(', ')}. #{e.message}.\n\n#{e.backtrace.join("\n")})
        # rubocop:enable Metrics/LineLength
      end
    end
  end
end
