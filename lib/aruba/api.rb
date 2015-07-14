require 'rspec/expectations'
require 'shellwords'

require 'aruba/version'
require 'aruba/extensions/string/strip'

require 'aruba/platform'
require 'aruba/api/core'
require 'aruba/api/command'

if Aruba::VERSION <= '1.0.0'
  require 'aruba/api/deprecated'
end

require 'aruba/api/environment'
require 'aruba/api/filesystem'
require 'aruba/api/rvm'

Aruba::Platform.require_matching_files('../matchers/**/*.rb', __FILE__)

module Aruba
  module Api
    include Aruba::Api::Core
    include Aruba::Api::Commands
    include Aruba::Api::Environment
    include Aruba::Api::Filesystem
    include Aruba::Api::Rvm
    include Aruba::Api::Deprecated

    # Access to announcer
    def announcer
      @announcer ||= Announcer.new(
        self,
        :stdout => @announce_stdout,
        :stderr => @announce_stderr,
        :dir    => @announce_dir,
        :cmd    => @announce_cmd,
        :env    => @announce_env
      )

      @announcer
    end

    module_function :announcer
  end
end
