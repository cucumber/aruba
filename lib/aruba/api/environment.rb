# frozen_string_literal: true

require 'aruba/platform'

# Aruba
module Aruba
  # Api
  module Api
    # Environment methods of aruba
    module Environment
      # Set environment variable
      #
      # @param [String] name
      #   The name of the environment variable as string, e.g. 'HOME'
      #
      # @param [String] value
      #   The value of the environment variable. Needs to be a string.
      #
      # @return [self]
      def set_environment_variable(name, value)
        name = name.to_s
        value = value.to_s

        old_environment = aruba.environment.to_h
        aruba.environment[name] = value
        new_environment = aruba.environment.to_h

        environment_change = { old: old_environment,
                               new: new_environment,
                               changed: { name: name, value: value } }
        aruba.event_bus.notify Events::AddedEnvironmentVariable.new(environment_change)

        self
      end

      # Append environment variable
      #
      # @param [String] name
      #   The name of the environment variable as string, e.g. 'HOME'
      #
      # @param [String] value
      #   The value of the environment variable. Needs to be a string.
      #
      # @return [self]
      def append_environment_variable(name, value)
        name = name.to_s
        value = value.to_s

        old_environment = aruba.environment.to_h
        aruba.environment.append name, value
        new_environment = aruba.environment.to_h

        environment_change = { old: old_environment,
                               new: new_environment,
                               changed: { name: name, value: value } }
        aruba.event_bus.notify Events::ChangedEnvironmentVariable.new(environment_change)

        self
      end

      # Prepend environment variable
      #
      # @param [String] name
      #   The name of the environment variable as string, e.g. 'HOME'
      #
      # @param [String] value
      #   The value of the environment variable. Needs to be a string.
      #
      # @return [self]
      def prepend_environment_variable(name, value)
        name = name.to_s
        value = value.to_s

        old_environment = aruba.environment.to_h
        aruba.environment.prepend name, value
        new_environment = aruba.environment.to_h

        environment_change = { old: old_environment,
                               new: new_environment,
                               changed: { name: name, value: value } }
        aruba.event_bus.notify Events::ChangedEnvironmentVariable.new(environment_change)

        self
      end

      # Remove existing environment variable
      #
      # @param [String] name
      #   The name of the environment variable as string, e.g. 'HOME'
      #
      # @return [self]
      def delete_environment_variable(name)
        name = name.to_s

        old_environment = aruba.environment.to_h
        aruba.environment.delete name
        new_environment = aruba.environment.to_h

        environment_change = { old: old_environment,
                               new: new_environment,
                               changed: { name: name, value: '' } }
        aruba.event_bus.notify Events::ChangedEnvironmentVariable.new(environment_change)

        self
      end
    end
  end
end
