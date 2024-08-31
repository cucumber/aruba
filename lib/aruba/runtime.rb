# frozen_string_literal: true

require 'aruba/configuration'
require 'aruba/aruba_path'
require 'aruba/config_wrapper'
require 'aruba/events'
require 'aruba/event_bus'

module Aruba
  # Runtime of aruba
  #
  # Most methods are considered private. Please look for `(private)` in the
  # attribute descriptions. Only a few like `#current_directory`,
  # '#root_directory` and `#config` are considered to be part of the public
  # API.
  class Runtime
    # @!attribute [r] current_directory
    #   Returns the current working directory
    #
    # @!attribute [r] root_directory
    #   Returns the root directory of aruba
    attr_reader :current_directory, :root_directory

    # @!attribute [r] config
    #   Access configuration of aruba
    #
    # @!attribute [r] environment
    #   Access environment of aruba (private)
    #
    # @!attribute [r] logger
    #   Logger of aruba (private)
    #
    # @!attribute [r] command_monitor
    #   Handler started commands (private)
    #
    # @!attribute [r] announcer
    #   Announce information
    #
    # @!attribute [r] event_bus
    #   Handle events (private)
    #
    attr_accessor :config, :environment, :logger, :command_monitor, :announcer, :event_bus

    def initialize(opts = {})
      @event_bus       = EventBus.new(Aruba::Events.registry)
      @announcer       = opts.fetch(:announcer, Aruba.platform.announcer.new)
      @config          = opts.fetch(:config,
                                    ConfigWrapper.new(Aruba.config.make_copy, @event_bus))
      @environment     = opts.fetch(:environment, Aruba.platform.environment_variables.new)
      @current_directory = ArubaPath.new(@config.working_directory)
      @root_directory    = ArubaPath.new(@config.root_directory)

      @environment.update(@config.command_runtime_environment)

      @command_monitor = opts.fetch(:command_monitor,
                                    Aruba.platform.command_monitor.new(announcer: @announcer))

      @logger = opts.fetch(:logger, Aruba.platform.logger.new)
      @logger.mode = @config.log_level

      @setup_done = false
    end

    # @private
    #
    # Setup of aruba is finshed. Should be used only internally.
    def setup_done
      @setup_done = true
    end

    # @private
    #
    # Has aruba already been setup. Should be used only internally.
    def setup_already_done?
      @setup_done == true
    end

    # The path to the directory which contains fixtures
    # You might want to overwrite this method to place your data else where.
    #
    # @return [ArubaPath]
    #   The directory to where your fixtures are stored
    def fixtures_directory
      @fixtures_directory ||= begin
        candidates = config.fixtures_directories.map { |dir| File.join(root_directory, dir) }
        directory = candidates.find { |d| Aruba.platform.directory? d }

        unless directory
          canditates_display = candidates.map { |d| format('"%s"', d) }.join(', ')
          raise "No existing fixtures directory found in #{canditates_display}."
        end

        directory
      end

      unless Aruba.platform.directory?(@fixtures_directory)
        raise %(Fixtures directory "#{@fixtures_directory}" is not a directory)
      end

      ArubaPath.new(@fixtures_directory)
    end
  end
end
