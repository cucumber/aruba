module Aruba
  # Aruba Hooks
  class Hooks
    def initialize
      @store = Hash.new do |hash, key|
        hash[key] = []
      end
    end

    def append(label, block)
      @store[label.to_sym] << block
    end

    def execute(label, context, *args)
      @store[label.to_sym].each do |block|
        context.instance_exec(*args, &block)
      end
    end
  end
end
