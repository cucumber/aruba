# frozen_string_literal: true

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
      # @option [Class, Module] type
      #   The type contract for the option
      #
      # @option [Object] default
      #   The default value
      def option_reader(name, type:, default: nil)
        raise ArgumentError, 'Either use block or default value' if block_given? && default

        add_option(name, block_given? ? yield(InConfigWrapper.new(known_options)) : default)

        Contract None => type
        define_method(name) { find_option(name).value }
      end

      # Define an option reader and writer
      #
      # @param [Symbol] name
      #   The name of the reader
      #
      # @option [Class, Module] type
      #   The type contract for the option
      #
      # @option [Object] default
      #   The default value
      #
      def option_accessor(name, type:, default: nil)
        raise ArgumentError, 'Either use block or default value' if block_given? && default

        # Add writer
        add_option(name, block_given? ? yield(InConfigWrapper.new(known_options)) : default)

        Contract type => type
        define_method(:"#{name}=") { |v| find_option(name).value = v }

        # Add reader
        option_reader name, type: type
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
      obj = dup
      obj.local_options = Marshal.load(Marshal.dump(local_options))
      obj.hooks         = @hooks

      obj
    end

    # Define before-hook
    #
    # @param [Symbol, String] name
    #   The name of the hook
    #
    # @yield
    #   The code block which should be run. This is a configure time only option
    def before(name, &block)
      name = format('%s_%s', 'before_', name.to_s).to_sym
      raise ArgumentError, 'A block is required' unless block

      @hooks.append(name, block)

      self
    end

    # Run before-hook
    #
    # @param [Symbol, String] name
    #   The name of the hook
    #
    # @param [Proc] context
    #   The context a hook should run in
    #
    # @param [Array] args
    #   Arguments for the run of hook
    def run_before_hook(name, context, *args)
      name = format('%s_%s', 'before_', name.to_s).to_sym

      @hooks.execute(name, context, *args)
    end

    # Define after-hook
    #
    # @param [Symbol, String] name
    #   The name of the hook
    #
    # @yield
    #   The code block which should be run. This is a configure time only option
    def after(name, &block)
      name = format('%s_%s', 'after_', name.to_s).to_sym
      raise ArgumentError, 'A block is required' unless block

      @hooks.append(name, block)

      self
    end

    # Run after-hook
    #
    # @param [Symbol, String] name
    #   The name of the hook
    #
    # @param [Proc] context
    #   The context a hook should run in
    #
    # @param [Array] args
    #   Arguments for the run of hook
    def run_after_hook(name, context, *args)
      name = format('%s_%s', 'after_', name.to_s).to_sym

      @hooks.execute(name, context, *args)
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
      public_send(:"#{name}=", *args) if option? name
    end

    private

    def initialize_configuration
      @local_options = Marshal.load(Marshal.dump(self.class.known_options))
      @hooks         = Hooks.new
    end

    def find_option(name)
      raise NotImplementedError, %(Unknown option "#{name}") unless option? name

      local_options[name]
    end
  end
end
