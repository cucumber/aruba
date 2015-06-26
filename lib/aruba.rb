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

require 'aruba/event'
require 'aruba/event_queue'

require 'aruba/utils'
require 'aruba/processes/spawn_process'
require 'aruba/processes/in_process'
require 'aruba/processes/debug_process'

require 'aruba/aruba_command'

require 'aruba/jruby'

require 'aruba/api/core'

module Aruba
  class << self
    attr_accessor :process
  end
  self.process = Aruba::Processes::SpawnProcess
end
