# frozen_string_literal: true

require 'aruba/platforms/unix_environment_variables'

# Aruba
module Aruba
  # Platforms
  module Platforms
    # Windows is case-insensitive when it accesses its environment variables.
    #
    # To work around this we turn all of the environment variable keys to
    # upper-case so that aruba is ensured that accessing environment variables
    # with upper-case keys will always work. See the following examples.
    #
    # @example Setting Windows environment variables using mixed case
    #   C:>set Path
    #   C:>Path=.;.\bin;c:\rubys\ruby-2.1.6-p336\bin;
    #   C:>set PATH
    #   C:>Path=.;.\bin;c:\rubys\ruby-2.1.6-p336\bin;
    #
    # @example If you access environment variables through ENV, you can access
    # values no matter the case of the key:
    #     ENV["Path"] # => ".;.\bin;c:\rubys\ruby-2.1.6-p336\bin;"
    #     ENV["PATH"] # => ".;.\bin;c:\rubys\ruby-2.1.6-p336\bin;"
    #
    # @example But if you copy the ENV to a hash, Ruby treats the keys as case sensitive:
    #   env_copy = ENV.to_hash
    #   # => {
    #   "ALLUSERSPROFILE"=>
    #     "C:\\ProgramData",
    #     "ANSICON"=>"119x1000 (119x58)",
    #     "ANSICON_DEF"=>"7",
    #     APPDATA" => "C:\\Users\\blorf\\AppData\\Roaming", ....
    #   }
    #   env["Path"]
    #   # => ".;.\bin;c:\rubys\ruby-2.1.6-p336\bin;"
    #   env["PATH"]
    #   # => nil
    class WindowsEnvironmentVariables < UnixEnvironmentVariables
      def initialize(env = ENV)
        super(upcase_env env)
      end

      def update(other_env, &block)
        super(upcase_env(other_env), &block)
      end

      def fetch(name, default = UnixEnvironmentVariables::UNDEFINED)
        super(name.upcase, default)
      end

      def key?(name)
        super(name.upcase)
      end

      def [](name)
        super(name.upcase)
      end

      def []=(name, value)
        super(name.upcase, value)
      end

      def append(name, value)
        super(name.upcase, value)
      end

      def prepend(name, value)
        super(name.upcase, value)
      end

      def delete(name)
        super(name.upcase)
      end

      def self.hash_from_env
        upcase_env(ENV)
      end

      def self.upcase_env(env)
        env.to_h.transform_keys { |k| k.to_s.upcase }
      end

      private

      def upcase_env(env)
        self.class.upcase_env(env)
      end
    end
  end
end
