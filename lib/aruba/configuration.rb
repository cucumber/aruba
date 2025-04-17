# frozen_string_literal: true

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
    option_reader :root_directory, type: String, default: Dir.getwd

    option_accessor :working_directory,
                    type: Aruba::Contracts::RelativePath,
                    default: 'tmp/aruba'

    option_reader :fixtures_path_prefix, type: String, default: '%'

    option_accessor :exit_timeout, type: Num, default: 15
    option_accessor :stop_signal, type: Maybe[String], default: nil
    option_accessor :io_wait_timeout, type: Num, default: 0.1
    option_accessor :startup_wait_time, type: Num, default: 0
    option_accessor :fixtures_directories,
                    type: ArrayOf[String],
                    default: %w[features/fixtures spec/fixtures test/fixtures fixtures]

    option_accessor :command_runtime_environment, type: Hash, default: {}
    option_accessor :command_search_paths,
                    type: ArrayOf[String] do |config|
                      [File.join(config.root_directory.value, 'bin'),
                       File.join(config.root_directory.value, 'exe')]
                    end
    option_accessor :remove_ansi_escape_sequences, type: Bool, default: true
    option_accessor :command_launcher,
                    type: Aruba::Contracts::Enum[:in_process, :spawn, :debug],
                    default: :spawn
    option_accessor :main_class, type: Maybe[Class], default: nil

    option_accessor :home_directory,
                    type: Or[Aruba::Contracts::AbsolutePath,
                             Aruba::Contracts::RelativePath] do |config|
      File.join(config.root_directory.value, config.working_directory.value)
    end

    option_accessor :log_level,
                    type:
                        Aruba::Contracts::Enum[:fatal, :warn, :debug, :info,
                                               :error, :unknown, :silent],
                    default: :info

    # TODO: deprecate this value and replace with "filesystem allocation unit"
    # equal to 4096 by default. "filesystem allocation unit" would represent
    # the actual MINIMUM space taken in bytes by a 1-byte file
    option_accessor :physical_block_size,
                    type: Aruba::Contracts::IsPowerOfTwo,
                    default: 512
    option_accessor :console_history_file, type: String,
                                           default: '~/.aruba_history'

    option_accessor :activate_announcer_on_command_failure,
                    type: ArrayOf[Symbol],
                    default: []
    option_accessor :allow_absolute_paths, type: Bool, default: false
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
