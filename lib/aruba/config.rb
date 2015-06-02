module Aruba
  # Aruba Configuration
  class Configuration < BasicConfiguration
    option_reader   :root_directory, contract: { None => String }, value: Dir.getwd
    option_accessor :current_directory, contract: { Array => Array }, default: %w(tmp aruba)
    option_reader   :fixtures_path_prefix, contract: { None => String }, value: ?%
    option_accessor :exit_timeout, contract: { Num => Num }, default: 3
    option_accessor :io_wait_timeout, contract: { Num => Num }, default: 0.1
    option_accessor :fixtures_directories, contract: { Array => ArrayOf[String] }, default: %w(features/fixtures spec/fixtures test/fixtures)
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
