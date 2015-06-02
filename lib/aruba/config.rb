module Aruba
  # Aruba Configuration
  class Configuration < BasicConfiguration
    option_reader :root_directory, value: Dir.getwd
    option_accessor :current_directory, contract: { Array => Array }, default: %w(tmp aruba)
  end
end

# Main Module
module Aruba
  @config = Configuration.new

  class << self
    attr_reader :config

    def configure(&block)
      @config.configure(&block)

      self
    end
  end
end

module Aruba
  # Old Config
  #
  # @private
  class Config < Configuration
    def initialize(*args)
      warn('The use of "Aruba::Config" is deprecated. Use "Aruba::Configuration" instead.')

      super
    end
  end
end
