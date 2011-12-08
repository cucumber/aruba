module Aruba
  class Config
    attr_reader :hooks
    
    def initialize
      @hooks = Hooks.new
    end
    
    # Register a hook to be called before Aruba runs a command
    def before_cmd(&block)
      @hooks.append(:before_cmd, block)
    end
  end
  
  #nodoc
  class Hooks
    def initialize
      @store = Hash.new do |hash, key|
        hash[key] = []
      end
    end
    
    def append(label, block)
      @store[label] << block
    end
    
    def execute(label, context, *args)
      @store[label].each do |block|
        context.instance_exec(*args, &block)
      end
    end
  end
  
  class << self
    attr_accessor :config

    def configure
      yield config
    end
    
  end
  
  self.config = Config.new
end
