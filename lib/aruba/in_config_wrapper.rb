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
      fail ArgumentError, 'Options take no argument' if args.any?
      fail UnknownOptionError, %(Option "#{name}" is unknown. Please use only earlier defined options) unless config.key? name

      config[name]
    end

    def respond_to_missing?(*)
      true
    end
  end
end
