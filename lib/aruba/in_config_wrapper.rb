# frozen_string_literal: true

# Aruba
module Aruba
  # In config wrapper
  #
  # Used to make the configuration read only if one needs to access an
  # configuration option from with `Aruba::Config`.
  #
  # @private
  class InConfigWrapper
    attr_reader :config
    private :config

    def initialize(config)
      @config = config.dup
    end

    def method_missing(name, *args)
      if config.key? name
        raise ArgumentError, 'Options take no argument' if args.any?

        config[name]
      else
        super
      end
    end

    def respond_to_missing?(name, _include_private)
      config.key? name
    end
  end
end
