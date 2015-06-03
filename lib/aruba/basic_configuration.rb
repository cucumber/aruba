module Aruba
  # Basic configuration for ProxyPacRb
  class BasicConfiguration
    include Contracts

    # A configuration option
    class Option
      attr_accessor :name
      attr_writer :value

      def initialize(name:, value:)
        @name  = name
        @value = value
      end

      def value
        @value.deep_dup
      end

      def deep_dup
        obj = self.dup
        obj.value = value

        obj
      end

      def ==(other)
        name == other.name && value == other.value
      end
    end

    class << self
      def known_options
        @known_options ||= {}
      end

      def option_reader(name, contract:, default: nil)
        fail ArgumentError, 'Either use block or default value' if block_given? && default

        Contract contract
        add_option(name, block_given? ? yield(ConfigWrapper.new(known_options)) : default)

        define_method(name) { find_option(name).value }

        self
      end

      def option_accessor(name, contract:, default: nil)
        fail ArgumentError, 'Either use block or default value' if block_given? && default
        fail ArgumentError, 'Either use block or default value' if !block_given? && default.nil? && default.empty?

        # Add writer
        add_option(name, block_given? ? yield(ConfigWrapper.new(known_options)) : default)

        Contract contract
        define_method("#{name}=") { |v| find_option(name).value = v }

        # Add reader
        option_reader name, contract: { None => contract.values.first }
      end

      private

      def add_option(name, value = nil)
        return if known_options.key?(name)

        known_options[name] = Option.new(name: name, value: value)

        self
      end
    end

    protected

    attr_accessor :local_options
    attr_writer :hooks

    public

    attr_reader :hooks

    def initialize
      initialize_configuration
    end

    # @yield [Configuration]
    #
    #   Yields self
    def configure
      yield self if block_given?
    end

    # Reset configuration
    def reset
      initialize_configuration
    end

    def deep_dup
      obj = self.dup
      obj.local_options = local_options.deep_dup
      obj.hooks         = hooks.deep_dup

      obj
    end

    def before(name, &block)
      hooks.append('before_' + name.to_s, block)
    end

    def after(name, &block)
      hooks.append('after_' + name.to_s, block)
    end

    def option?(name)
      local_options.any? { |_, v| v.name == name }
    end

    def ==(other)
      local_options.values.map(&:value) == other.local_options.values.map(&:value)
    end

    # Set if name is option
    def set_if_option(name, *args)
      public_send("#{name}=".to_sym, *args) if option? name
    end

    private

    def initialize_configuration
      @local_options = self.class.known_options.deep_dup
      @hooks         = Hooks.new
    end

    def find_option(name)
      fail NotImplementedError, %(Unknown option "#{name}") unless option? name

      local_options[name]
    end
  end
end
