require 'aruba/platform'

module Aruba
  module Api
    # Environment methods of aruba
    module Environment
      # Set environment variable
      #
      # @param [String] key
      #   The name of the environment variable as string, e.g. 'HOME'
      #
      # @param [String] value
      #   The value of the environment variable. Needs to be a string.
      def set_environment_variable(name, value)
        name = name.to_s
        value = value.to_s

        announcer.announce(:environment, name, value)
        announcer.announce(:modified_environment, name, value)

        aruba.environment[name] = value

        self
      end

      # Append environment variable
      #
      # @param [String] key
      #   The name of the environment variable as string, e.g. 'HOME'
      #
      # @param [String] value
      #   The value of the environment variable. Needs to be a string.
      def append_environment_variable(name, value)
        name = name.to_s
        value = value.to_s

        aruba.environment.append name, value
        announcer.announce(:environment, name, aruba.environment[name])
        announcer.announce(:modified_environment, name, aruba.environment[name])

        self
      end

      # Prepend environment variable
      #
      # @param [String] key
      #   The name of the environment variable as string, e.g. 'HOME'
      #
      # @param [String] value
      #   The value of the environment variable. Needs to be a string.
      def prepend_environment_variable(name, value)
        name = name.to_s
        value = value.to_s

        aruba.environment.prepend name, value
        announcer.announce(:environment, name, aruba.environment[name])
        announcer.announce(:modified_environment, name, aruba.environment[name])

        self
      end
    end
  end
end
