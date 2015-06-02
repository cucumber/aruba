require 'contracts'
require 'rspec/expectations'

require 'fileutils'
require 'rbconfig'
require 'ostruct'
require 'pathname'

require 'aruba/extensions/object/deep_dup'
require 'aruba/extensions/string/strip'

require 'aruba/errors'
require 'aruba/hooks'

require 'aruba/config_wrapper'
require 'aruba/basic_configuration'
require 'aruba/config'
require 'aruba/announcer'
require 'aruba/command_monitor'
require 'aruba/runtime'

require 'aruba/utils'
require 'aruba/spawn_process'

require 'aruba/jruby'

require 'aruba/api/core'

module Aruba
  class << self
    attr_accessor :process
  end
  self.process = Aruba::Processes::SpawnProcess
end
