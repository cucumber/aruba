module Aruba
  class Runtime
    attr_reader :config

    def initialize
      @config = Aruba.config.deep_dup
    end
  end
end
