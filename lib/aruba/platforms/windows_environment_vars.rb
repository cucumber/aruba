require 'aruba/environment'

module Aruba
  #
  # Windows is case-insensitive when it accesses its environment variables.  That means that
  # at the Windows command line:
  #  C:>set Path
  #  C:>Path=.;.\bin;c:\rubys\ruby-2.1.6-p336\bin;
  #  C:>set PATH
  #  C:>Path=.;.\bin;c:\rubys\ruby-2.1.6-p336\bin;
  #
  # If you access environment variables through ENV, you can access values no matter the
  # case of the key:
  #  irb: > ENV["Path"]
  #  => ".;.\bin;c:\rubys\ruby-2.1.6-p336\bin;"
  #  irb: > ENV["Path"]
  #  => ".;.\bin;c:\rubys\ruby-2.1.6-p336\bin;"
  #
  # But if you copy the ENV to a hash, Ruby treats the keys as case sensitive:
  #  irb: > env_copy = ENV.to_hash
  #  => {"ALLUSERSPROFILE"=>"C:\\ProgramData", "ANSICON"=>"119x1000 (119x58)", "ANSICON_DEF"=>"7",  APPDATA"=>"C:\\Users\\blorf\\AppData\\Roaming", ....}
  #  irb: > env["Path"]
  #  => ".;.\bin;c:\rubys\ruby-2.1.6-p336\bin;"
  #  irb: > env["PATH"]
  #  => nil
  #
  # Thus we turn all of the environment variable keys to upper case so that aruba is ensured that
  # accessing environment variables with upper case keys will always work.
  #
  # TODO: investigate unicode characters that don't respond to [String].upcase
  #
  class WindowsEnvironmentVars < Environment
    def initialize
      super
      # rubocop:disable Style/EachWithObject
      @env = ENV.to_hash.dup.inject({}) { |new_env, (k,v)| new_env[k.to_s.upcase] = v; new_env } #compatible with ruby < 1.9
      # rubocop:enable Style/EachWithObject
    end
  end
end
