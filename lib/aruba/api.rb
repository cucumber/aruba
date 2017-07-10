require 'rspec/expectations'
require 'shellwords'

require 'aruba/version'
require 'aruba/extensions/string/strip'

require 'aruba/platform'
require 'aruba/api/core'
require 'aruba/api/command'

if Aruba::VERSION <= '1.1.0'
  require 'aruba/api/deprecated'
end

require 'aruba/api_builder'

require 'aruba/api/environment'
require 'aruba/api/filesystem'
require 'aruba/api/text'
require 'aruba/api/rvm'

Aruba.platform.require_matching_files('../matchers/**/*.rb', __FILE__)

# Aruba
module Aruba
  # Api
  module Api
    include Aruba::Api::Core
    include Aruba::Api::Commands
    include Aruba::Api::Environment
    include Aruba::Api::Filesystem
    include Aruba::Api::Rvm
    if Aruba::VERSION <= '1.1.0'
      include Aruba::Api::Deprecated
    end
    include Aruba::Api::Text
  end
end
