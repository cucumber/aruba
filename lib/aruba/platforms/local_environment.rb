# Aruba
module Aruba
  # Platforms
  module Platforms
    # Local environemnt
    #
    # Wraps logic to make enviroment local and restorable
    class LocalEnvironment
      # Run in environment
      #
      # @param [Hash] env
      #   The environment
      #
      # @yield
      #   The block of code which should with local ENV
      def call(env)
        old_env = Aruba.platform.environment_variables.hash_from_env

        ENV.clear
        ENV.update env

        yield if block_given?
      ensure
        ENV.clear
        ENV.update old_env
      end
    end
  end
end
