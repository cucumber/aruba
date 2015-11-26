require 'contracts'
require 'aruba/basic_configuration/option'
require 'aruba/in_config_wrapper'

# Aruba
module Aruba
  # Basic configuration for Aruba
  #
  # @private
  class BasicConfiguration
    include Contracts

    class << self
      def known_options
        @known_options ||= {}
      end

      # Define an option reader
      #
      # @param [Symbol] name
      #   The name of the reader
      #
      # @param [Hash] opts
      #   Options
      #
      # @option [Class, Module] contract
      #   The contract for the option
      #
      # @option [Object] default
      #   The default value
      def option_reader(name, opts = {})
        contract = opts[:contract]
        default  = opts[:default]

        fail ArgumentError, 'Either use block or default value' if block_given? && default
        fail ArgumentError, 'contract-options is required' if contract.nil?

        Contract contract
        add_option(name, block_given? ? yield(InConfigWrapper.new(known_options)) : default)

        define_method(name) { find_option(name).value }

        self
      end

      # Define an option reader and writer
      #
      # @param [Symbol] name
      #   The name of the reader
      #
      # @param [Hash] opts
      #   Options
      #
      # @option [Class, Module] contract
      #   The contract for the option
      #
      # @option [Object] default
      #   The default value
      #
      # rubocop:disable Metrics/CyclomaticComplexity
      def option_accessor(name, opts = {})
        contract = opts[:contract]
        default  = opts[:default]

        fail ArgumentError, 'Either use block or default value' if block_given? && default
        # fail ArgumentError, 'Either use block or default value' if !block_given? && default.nil? && default.to_s.empty?
        fail ArgumentError, 'contract-options is required' if contract.nil?

        # Add writer
        add_option(name, block_given? ? yield(InConfigWrapper.new(known_options)) : default)

        Contract contract
        define_method("#{name}=") { |v| find_option(name).value = v }

        # Add reader
        option_reader name, :contract => { None => contract.values.first }
      end
      # rubocop:enable Metrics/CyclomaticComplexity

      private

      def add_option(name, value = nil)
        return if known_options.key?(name)

        known_options[name] = Option.new(:name => name, :value => value)

        self
      end
    end

    protected

    attr_accessor :local_options
    attr_writer :hooks

    # attr_reader :hooks

    public

    # Create configuration
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

    # Make deep dup copy of configuration
    def make_copy
      obj = self.dup
      obj.local_options = Marshal.load(Marshal.dump(local_options))
      obj.hooks         = @hooks

      obj
    end

    # Get access to hooks
    def hooks
      # rubocop:disable Metrics/LineLength
      Aruba.platform.deprecated 'The use of the "#aruba.config.hooks" is deprecated. Please use "#aruba.config.before(:name) {}" to define and "#aruba.config.before(:name, *args)" to run a hook. This method will become private in the next major version.'
      # rubocop:enable Metrics/LineLength

      @hooks
    end

    # @deprecated
    def before_cmd(&block)
      Aruba.platform.deprecated 'The use of the "#before_cmd"-hook is deprecated. Please define with "#before(:command) {}" instead'

      before(:command, &block)
    end

    # Define or run before-hook
    #
    # @param [Symbol, String] name
    #   The name of the hook
    #
    # @param [Proc] context
    #   The context a hook should run in. This is a runtime only option.
    #
    # @param [Array] args
    #   Arguments for the run of hook. This is a runtime only option.
    #
    # @yield
    #   The code block which should be run. This is a configure time only option
    def before(name, context = proc {}, *args, &block)
      name = format('%s_%s', 'before_', name.to_s).to_sym

      if block_given?
        @hooks.append(name, block)

        self
      else
        @hooks.execute(name, context, *args)
      end
    end

    # Define or run after-hook
    #
    # @param [Symbol, String] name
    #   The name of the hook
    #
    # @param [Proc] context
    #   The context a hook should run in. This is a runtime only option.
    #
    # @param [Array] args
    #   Arguments for the run of hook. This is a runtime only option.
    #
    # @yield
    #   The code block which should be run. This is a configure time only option
    def after(name, context = proc {}, *args, &block)
      name = format('%s_%s', 'after_', name.to_s).to_sym

      if block_given?
        @hooks.append(name, block)

        self
      else
        @hooks.execute(name, context, *args)
      end
    end

    # Check if before-hook <name> is defined
    def before?(name)
      name = format('%s_%s', 'before_', name.to_s).to_sym

      @hooks.exist? name
    end

    # Check if after-hook <name> is defined
    def after?(name)
      name = format('%s_%s', 'after_', name.to_s).to_sym

      @hooks.exist? name
    end

    # Check if <name> is option
    #
    # @param [String, Symbol] name
    #   The name of the option
    def option?(name)
      local_options.any? { |_, v| v.name == name.to_sym }
    end

    def ==(other)
      local_options.values.map(&:value) == other.local_options.values.map(&:value)
    end

    # Set if name is option
    def set_if_option(name, *args)
      if RUBY_VERSION < '1.9'
        send("#{name}=".to_sym, *args) if option? name
      else
        public_send("#{name}=".to_sym, *args) if option? name
      end
    end

    private

    def initialize_configuration
      @local_options = Marshal.load(Marshal.dump(self.class.known_options))
      @hooks         = Hooks.new
    end

    def find_option(name)
      fail NotImplementedError, %(Unknown option "#{name}") unless option? name

      local_options[name]
    end
  end
end
