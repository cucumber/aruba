# frozen_string_literal: true

require 'aruba/api/environment'
require 'bundler'

module Aruba
  module Api
    module Bundler
      include Environment

      # Unset variables used by bundler
      def unset_bundler_env_vars
        empty_env = with_environment { with_unbundled_env { ENV.to_h } }
        aruba_env = aruba.environment.to_h
        (aruba_env.keys - empty_env.keys).each do |key|
          delete_environment_variable key
        end
        empty_env.each do |k, v|
          set_environment_variable k, v
        end
      end

      private

      def with_unbundled_env(&block)
        if ::Bundler.respond_to?(:with_unbundled_env)
          ::Bundler.with_unbundled_env(&block)
        else
          ::Bundler.with_clean_env(&block)
        end
      end
    end
  end
end
