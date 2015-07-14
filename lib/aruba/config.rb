require 'contracts'

require 'aruba/version'
require 'aruba/basic_configuration'
require 'aruba/config_wrapper'
require 'aruba/hooks'
require 'aruba/contracts/relative_path'
require 'aruba/contracts/absolute_path'
require 'aruba/contracts/enum'
require 'aruba/contracts/is_a'

module Aruba
  # Aruba Configuration
  class Configuration < BasicConfiguration
    if Aruba::VERSION >= '1.0.0'
      option_reader :root_directory, :contract => { None => String }, :default => Dir.getwd
    else
      option_accessor :root_directory, :contract => { String => String }, :default => Dir.getwd
    end

    option_accessor :working_directory, :contract => { Aruba::Contracts::RelativePath => Aruba::Contracts::RelativePath }, :default => 'tmp/aruba'

    if RUBY_VERSION < '1.9'
      option_reader   :fixtures_path_prefix, :contract => { None => String }, :default => '%'
    else
      option_reader   :fixtures_path_prefix, :contract => { None => String }, :default => ?%
    end

    option_accessor :exit_timeout, :contract => { Num => Num }, :default => 15
    option_accessor :io_wait_timeout, :contract => { Num => Num }, :default => 0.1
    option_accessor :fixtures_directories, :contract => { Array => ArrayOf[String] }, :default => %w(features/fixtures spec/fixtures test/fixtures)
    option_accessor :command_runtime_environment, :contract => { Hash => Hash }, :default => ENV.to_hash
    # rubocop:disable Metrics/LineLength
    option_accessor(:command_search_paths, :contract => { ArrayOf[String] => ArrayOf[String] }) { |config| [File.join(config.root_directory.value, 'bin')] }
    # rubocop:enable Metrics/LineLength
    option_accessor :keep_ansi, :contract => { Bool => Bool }, :default => false
    # rubocop:disable Metrics/LineLength
    option_accessor :command_launcher, :contract => { Aruba::Contracts::Enum[:in_process, :spawn, :debug] => Aruba::Contracts::Enum[:in_process, :spawn, :debug] }, :default => :spawn
    # rubocop:enable Metrics/LineLength
    option_accessor :main_class, :contract => { Aruba::Contracts::IsA[Class] => Or[Aruba::Contracts::IsA[Class], Eq[nil]] }, :default => nil
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
