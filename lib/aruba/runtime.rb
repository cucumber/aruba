require 'aruba/config'

module Aruba
  class Runtime
    attr_reader :config

    def initialize
      @config = Aruba.config.make_copy
    end
  end
end
