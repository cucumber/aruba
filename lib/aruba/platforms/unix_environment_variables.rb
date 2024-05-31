# frozen_string_literal: true

# Aruba
module Aruba
  # Platforms
  module Platforms
    # Abstract environment variables
    class UnixEnvironmentVariables
      # Update environment
      class UpdateAction
        attr_reader :other_env, :block

        def initialize(other_env, &block)
          @other_env = other_env.to_h.transform_values(&:to_s)

          @block = block
        end

        def call(env)
          if block
            env.update(other_env, &block)
          else
            env.update(other_env)
          end
        end
      end

      # Remove variables from environment
      class RemoveAction
        attr_reader :variables

        def initialize(variables)
          @variables = Array(variables)
        end

        def call(env)
          variables.each { |v| env.delete v }

          env
        end
      end

      # We need to use this, because `nil` is a valid value as default
      UNDEFINED = Object.new.freeze

      private

      attr_reader :actions, :env

      public

      def initialize(env = ENV)
        @actions = []

        @env = env.to_h
      end

      # Update environment with other en
      #
      # @param [#to_hash, #to_h] other_env
      #   Another environment object or hash
      #
      # @yield
      #   Pass block to env
      def update(other_env)
        actions << UpdateAction.new(other_env)

        self
      end

      # Fetch variable from environment
      #
      # @param [#to_s] name
      #   The name of the variable
      #
      # @param [Object] default
      #   The default value used, if the variable is not defined
      def fetch(name, default = UNDEFINED)
        if default == UNDEFINED
          to_h.fetch name.to_s
        else
          to_h.fetch name.to_s, default
        end
      end

      # Check if variable exist
      #
      # @param [#to_s] name
      #   The name of the variable
      def key?(name)
        to_h.key? name.to_s
      end

      # Get value of variable
      #
      # @param [#to_s] name
      #   The name of the variable
      def [](name)
        to_h[name.to_s]
      end

      # Set value of variable
      #
      # @param [#to_s] name
      #   The name of the variable
      #
      # @param [#to_s] value
      #   The value of the variable
      def []=(name, value)
        value = value.to_s

        actions << UpdateAction.new(name.to_s => value)
      end

      # Append value to variable
      #
      # @param [#to_s] name
      #   The name of the variable
      #
      # @param [#to_s] value
      #   The value of the variable
      def append(name, value)
        name  = name.to_s
        value = self[name].to_s + value.to_s

        actions << UpdateAction.new(name => value)

        value
      end

      # Prepend value to variable
      #
      # @param [#to_s] name
      #   The name of the variable
      #
      # @param [#to_s] value
      #   The value of the variable
      def prepend(name, value)
        name  = name.to_s
        value = value.to_s + self[name].to_s

        actions << UpdateAction.new(name => value)

        value
      end

      # Delete variable
      #
      # @param [#to_s] name
      #   The name of the variable
      def delete(name)
        # Rescue value, before it is deleted
        value = to_h[name.to_s]

        actions << RemoveAction.new(name.to_s)

        value
      end

      # Pass on checks
      def method_missing(name, ...)
        super unless to_h.respond_to? name

        to_h.send(name, ...)
      end

      # Check for respond_to
      def respond_to_missing?(name, _private)
        to_h.respond_to? name
      end

      # Convert to hash
      #
      # @return [Hash]
      #   A new hash from environment
      def to_h
        actions.inject(hash_from_env.merge(env)) { |a, e| e.call(a) }
      end

      # Reset environment
      def clear
        value = to_h

        actions.clear

        value
      end

      def nest
        old_actions = @actions.dup
        yield(self)
      ensure
        @actions = old_actions
      end

      def self.hash_from_env
        ENV.to_hash
      end

      private

      def hash_from_env
        self.class.hash_from_env
      end
    end
  end
end
