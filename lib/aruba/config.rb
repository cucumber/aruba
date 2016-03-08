require 'contracts'

require 'aruba/version'
require 'aruba/basic_configuration'
require 'aruba/in_config_wrapper'
require 'aruba/hooks'

require 'aruba/contracts/relative_path'
require 'aruba/contracts/absolute_path'
require 'aruba/contracts/enum'

require 'aruba/contracts/is_power_of_two'

# Aruba
module Aruba
  # Aruba Configuration
  #
  # This defines the configuration options of aruba
  class Configuration < BasicConfiguration
    if Aruba::VERSION >= '1.0.0'
      option_reader :root_directory, :contract => { None => String }, :default => Dir.getwd
    else
      option_accessor :root_directory, :contract => { String => String }, :default => Dir.getwd
    end

    option_accessor :working_directory, :contract => { Aruba::Contracts::RelativePath => Aruba::Contracts::RelativePath }, :default => 'tmp/aruba'

    if RUBY_VERSION < '1.9'
      option_reader :fixtures_path_prefix, :contract => { None => String }, :default => '%'
    else
      option_reader :fixtures_path_prefix, :contract => { None => String }, :default => ?%
    end

    option_accessor :exit_timeout, :contract => { Num => Num }, :default => 15
    option_accessor :stop_signal, :contract => { Maybe[String] => Maybe[String] }, :default => nil
    option_accessor :io_wait_timeout, :contract => { Num => Num }, :default => 0.1
    option_accessor :startup_wait_time, :contract => { Num => Num }, :default => 0
    option_accessor :fixtures_directories, :contract => { Array => ArrayOf[String] }, :default => %w(features/fixtures spec/fixtures test/fixtures fixtures)
    option_accessor :command_runtime_environment, :contract => { Hash => Hash }, :default => ENV.to_hash
    # rubocop:disable Metrics/LineLength
    option_accessor(:command_search_paths, :contract => { ArrayOf[String] => ArrayOf[String] }) { |config| [File.join(config.root_directory.value, 'bin'), File.join(config.root_directory.value, 'exe')] }
    # rubocop:enable Metrics/LineLength
    option_accessor :keep_ansi, :contract => { Bool => Bool }, :default => false
    option_accessor :remove_ansi_escape_sequences, :contract => { Bool => Bool }, :default => true
    # rubocop:disable Metrics/LineLength
    option_accessor :command_launcher, :contract => { Aruba::Contracts::Enum[:in_process, :spawn, :debug] => Aruba::Contracts::Enum[:in_process, :spawn, :debug] }, :default => :spawn
    # rubocop:enable Metrics/LineLength
    option_accessor :main_class, :contract => { Class => Maybe[Class] }, :default => nil
    # rubocop:disable Metrics/LineLength

    # rubocop:disable Metrics/LineLength
    if Aruba::VERSION >= '1.0.0'
      option_accessor :home_directory, :contract => { Or[Aruba::Contracts::AbsolutePath, Aruba::Contracts::RelativePath] => Or[Aruba::Contracts::AbsolutePath, Aruba::Contracts::RelativePath] } do |config|
        File.join(config.root_directory.value, config.working_directory.value)
      end
    else
      option_accessor :home_directory, :contract => { Or[Aruba::Contracts::AbsolutePath, Aruba::Contracts::RelativePath] => Or[Aruba::Contracts::AbsolutePath, Aruba::Contracts::RelativePath] }, :default => ENV['HOME']
    end
    # rubocop:enable Metrics/LineLength

    # rubocop:disable Metrics/LineLength
    option_accessor :log_level, :contract => { Aruba::Contracts::Enum[:fatal, :warn, :debug, :info, :error, :unknown, :silent] => Aruba::Contracts::Enum[:fatal, :warn, :debug, :info, :error, :unknown, :silent] }, :default => :info
    # rubocop:enable Metrics/LineLength

    option_accessor :physical_block_size, :contract => { Aruba::Contracts::IsPowerOfTwo => Aruba::Contracts::IsPowerOfTwo }, :default => 512
    option_accessor :console_history_file, :contract => { String => String }, :default => '~/.aruba_history'

    option_accessor :activate_announcer_on_command_failure, :contract => { ArrayOf[Symbol] => ArrayOf[Symbol] }, :default => []
  end
end

# Aruba
module Aruba
  @config = Configuration.new

  class << self
    attr_reader :config

    # Configure aruba
    #
    # @example How to configure aruba
    #
    #   Aruba.configure do |config|
    #     config.<option> = <value>
    #   end
    #
    def configure(&block)
      @config.configure(&block)

      self
    end
  end
end

# Aruba
module Aruba
  # Old Config
  #
  # @private
  # @deprecated
  class Config < Configuration
    def initialize(*args)
      warn('The use of "Aruba::Config" is deprecated. Use "Aruba::Configuration" instead.')

      super
    end
  end
end
