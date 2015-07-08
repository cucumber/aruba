module Aruba
  # Aruba Hooks
  class Hooks
    private

    attr_reader :store

    public

    def initialize
      @store = {}
    end

    def append(label, block)
      if store.key?(label.to_sym) && store[label.to_sym].respond_to?(:<<)
        store[label.to_sym] << block
      else
        store[label.to_sym] = []
        store[label.to_sym] << block
      end
    end

    def execute(label, context, *args)
      Array(store[label.to_sym]).each do |block|
        context.instance_exec(*args, &block)
      end
    end

    def exist?(label)
      store.key? label.to_sym
    end
  end
end
