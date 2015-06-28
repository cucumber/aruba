require 'aruba/process_monitor'
require 'aruba/spawn_process'

module Aruba
  class << self
    attr_accessor :process
  end

  self.process = Aruba::Processes::SpawnProcess
end
