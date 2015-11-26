# Aruba
module Aruba
  # Aruba Hooks
  class Hooks
    private

    attr_reader :store

    public

    # Create store
    def initialize
      @store = {}
    end

    # Add new hook
    #
    # @param [String, Symbol] label
    #   The name of the hook
    #
    # @para [Proc] block
    #   The block which should be run for the hook
    def append(label, block)
      if store.key?(label.to_sym) && store[label.to_sym].respond_to?(:<<)
        store[label.to_sym] << block
      else
        store[label.to_sym] = []
        store[label.to_sym] << block
      end
    end

    # Run hook
    #
    # @param [String, Symbol] label
    #   The name of the hook
    #
    # @param [Object] context
    #   The context in which the hook is run
    #
    # @param [Array] args
    #   Other arguments
    def execute(label, context, *args)
      Array(store[label.to_sym]).each do |block|
        context.instance_exec(*args, &block)
      end
    end

    # Check if hook exist
    #
    # @param [String, Symbol] label
    #   The name of the hook
    def exist?(label)
      store.key? label.to_sym
    end
  end
end
