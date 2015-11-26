# Aruba
module Aruba
  # Platforms
  module Platforms
    # Abstract environment variables
    class UnixEnvironmentVariables
      # We need to use this, because `nil` is a valid value as default
      UNDEFINED = Object.new.freeze

      private

      attr_reader :env

      public

      def initialize(env = ENV.to_hash)
        @env = Marshal.load(Marshal.dump(env))
      end

      # Update environment with other en
      #
      # @param [#to_hash, #to_h] other_env
      #   Another environment object or hash
      #
      # @yield
      #   Pass block to env
      def update(other_env, &block)
        if RUBY_VERSION <= '1.9.3'
          # rubocop:disable Style/EachWithObject
          other_env = other_env.to_hash.inject({}) { |a, (k, v)| a[k] = v.to_s; a }
          # rubocop:enable Style/EachWithObject
        else
          other_env = other_env.to_h.each_with_object({}) { |(k, v), a| a[k] = v.to_s }
        end

        env.update(other_env, &block)

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
          env.fetch name.to_s
        else
          env.fetch name.to_s, default
        end
      end

      # Check if variable exist
      #
      # @param [#to_s] name
      #   The name of the variable
      def key?(name)
        env.key? name.to_s
      end

      # Get value of variable
      #
      # @param [#to_s] name
      #   The name of the variable
      def [](name)
        env[name.to_s]
      end

      # Set value of variable
      #
      # @param [#to_s] name
      #   The name of the variable
      #
      # @param [#to_s] value
      #   The value of the variable
      def []=(name, value)
        env[name.to_s] = value.to_s

        self
      end

      # Append value to variable
      #
      # @param [#to_s] name
      #   The name of the variable
      #
      # @param [#to_s] value
      #   The value of the variable
      def append(name, value)
        name = name.to_s
        env[name] = env[name].to_s + value.to_s

        self
      end

      # Prepend value to variable
      #
      # @param [#to_s] name
      #   The name of the variable
      #
      # @param [#to_s] value
      #   The value of the variable
      def prepend(name, value)
        name = name.to_s
        env[name] = value.to_s + env[name].to_s

        self
      end

      # Delete variable
      #
      # @param [#to_s] name
      #   The name of the variable
      def delete(name)
        env.delete name.to_s

        self
      end

      # Convert to hash
      #
      # @return [Hash]
      #   A new hash from environment
      def to_h
        if RUBY_VERSION < '2.0'
          Marshal.load(Marshal.dump(env.to_hash))
        else
          Marshal.load(Marshal.dump(env.to_h))
        end
      end

      # Reset environment
      def clear
        env.clear

        self
      end
    end
  end
end
