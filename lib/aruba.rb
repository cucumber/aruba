require 'aruba/process'

module Aruba
  class << self
    attr_accessor :process
  end
  self.process = Aruba::Process
end