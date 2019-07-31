require 'rspec/expectations'
require 'shellwords'

require 'aruba/version'
require 'aruba/extensions/string/strip'
require 'aruba/extensions/object/to_h'

require 'aruba/platform'
require 'aruba/api/core'
require 'aruba/api/commands'

require 'aruba/api/environment'
require 'aruba/api/filesystem'
require 'aruba/api/text'
require 'aruba/api/bundler'

Aruba.platform.require_matching_files('../matchers/**/*.rb', __FILE__)

# Aruba
module Aruba
  # Api
  module Api
    include Core
    include Commands
    include Environment
    include Filesystem
    include Text
    include Bundler
  end
end
