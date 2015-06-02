require 'contracts'
require 'rspec/expectations'

require 'fileutils'
require 'rbconfig'
require 'ostruct'
require 'pathname'

require 'aruba/extensions/duplicable'
require 'aruba/extensions/deep_dup'

require 'aruba/errors'
require 'aruba/basic_configuration'
require 'aruba/config_wrapper'
require 'aruba/config'
require 'aruba/process_monitor'
require 'aruba/utils'
require 'aruba/announcer'

require 'aruba/spawn_process'

module Aruba
  class << self
    attr_accessor :process
  end
  self.process = Aruba::Processes::SpawnProcess
end
