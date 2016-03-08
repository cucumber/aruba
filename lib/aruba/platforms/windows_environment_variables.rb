require 'aruba/platforms/unix_environment_variables'

# Aruba
module Aruba
  # Platforms
  module Platforms
    # Windows is case-insensitive when it accesses its environment variables.
    # That means that at the Windows command line:
    #
    #  C:>set Path
    #  C:>Path=.;.\bin;c:\rubys\ruby-2.1.6-p336\bin;
    #  C:>set PATH
    #  C:>Path=.;.\bin;c:\rubys\ruby-2.1.6-p336\bin;
    #
    # If you access environment variables through ENV, you can access values no
    # matter the case of the key:
    #
    #  irb: > ENV["Path"]
    #  => ".;.\bin;c:\rubys\ruby-2.1.6-p336\bin;"
    #  irb: > ENV["Path"]
    #  => ".;.\bin;c:\rubys\ruby-2.1.6-p336\bin;"
    #
    # But if you copy the ENV to a hash, Ruby treats the keys as case sensitive:
    #
    #  irb: > env_copy = ENV.to_hash
    #  => {"ALLUSERSPROFILE"=>"C:\\ProgramData", "ANSICON"=>"119x1000 (119x58)", "ANSICON_DEF"=>"7",  APPDATA"=>"C:\\Users\\blorf\\AppData\\Roaming", ....}
    #  irb: > env["Path"]
    #  => ".;.\bin;c:\rubys\ruby-2.1.6-p336\bin;"
    #  irb: > env["PATH"]
    #  => nil
    #
    # Thus we turn all of the environment variable keys to upper case so that
    # aruba is ensured that accessing environment variables with upper case keys
    # will always work.
    class WindowsEnvironmentVariables < UnixEnvironmentVariables
      def initialize(env = ENV.to_hash)
        @actions = []

        @env = if RUBY_VERSION <= '1.9.3'
                 # rubocop:disable Style/EachWithObject
                 env.inject({}) { |a, (k,v)| a[k.to_s.upcase] = v; a }
               # rubocop:enable Style/EachWithObject
               else
                 env.each_with_object({}) { |(k,v), a| a[k.to_s.upcase] = v }
               end
      end

      def update(other_env, &block)
        other_env = if RUBY_VERSION <= '1.9.3'
                      # rubocop:disable Style/EachWithObject
                      other_env.inject({}) { |a, (k,v)| a[k.to_s.upcase] = v; a }
                    # rubocop:enable Style/EachWithObject
                    else
                      other_env.each_with_object({}) { |(k,v), a| a[k.to_s.upcase] = v }
                    end

        super(other_env, &block)
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

      def delete(name, value)
        super(name.upcase, value)
      end
    end
  end
end
