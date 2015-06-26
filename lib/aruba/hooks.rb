module Aruba
  # Aruba Hooks
  class Hooks
    def initialize
      @store = {}
    end

    def append(label, block)
      if @store.key?(label.to_sym) && @store[label.to_sym].respond_to?(:<<)
        @store[label.to_sym] << block
      else
        @store[label.to_sym] = []
        @store[label.to_sym] << block
      end
    end

    def execute(label, context, *args)
      @store[label.to_sym].each do |block|
        context.instance_exec(*args, &block)
      end
    end
  end
end
