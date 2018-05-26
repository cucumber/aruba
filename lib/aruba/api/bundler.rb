require 'aruba/api/environment'

module Aruba
  module Api
    module Bundler
      include Environment

      # Unset variables used by bundler
      def unset_bundler_env_vars
        %w[RUBYOPT BUNDLE_PATH BUNDLE_BIN_PATH BUNDLE_GEMFILE].each do |key|
          delete_environment_variable(key)
        end
      end
    end
  end
end
