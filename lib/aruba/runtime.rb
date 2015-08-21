require 'aruba/config'
require 'aruba/aruba_path'
require 'aruba/config_wrapper'
require 'aruba/events'
require 'event/bus'

module Aruba
  class Runtime
    attr_reader :current_directory, :root_directory
    attr_accessor :config, :environment, :logger, :command_monitor, :announcer, :event_bus

    def initialize(opts = {})
      @environment     = opts.fetch(:environment, Aruba.platform.environment_variables)
      @event_bus     = ::Event::Bus.new(::Event::NameResolver.new(Aruba::Events))
      @announcer       = opts.fetch(:announcer, Aruba.platform.announcer.new)

      @config            = opts.fetch(:config, ConfigWrapper.new(Aruba.config.make_copy, @event_bus))
      @current_directory = ArubaPath.new(@config.working_directory)
      @root_directory    = ArubaPath.new(@config.root_directory)

      if Aruba::VERSION < '1'
        @command_monitor = opts.fetch(:command_monitor, Aruba.platform.command_monitor.new(event_bus: @event_bus, announcer: @announcer))
      else
        @command_monitor = opts.fetch(:command_monitor, Aruba.platform.command_monitor.new(event_bus: @event_bus))
      end

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
      unless @fixtures_directory
        candidates = config.fixtures_directories.map { |dir| File.join(root_directory, dir) }
        @fixtures_directory = candidates.find { |d| Aruba.platform.directory? d }

        fail "No existing fixtures directory found in #{candidates.map { |d| format('"%s"', d) }.join(', ')}. " unless @fixtures_directory
      end

      fail %(Fixtures directory "#{@fixtures_directory}" is not a directory) unless Aruba.platform.directory?(@fixtures_directory)

      ArubaPath.new(@fixtures_directory)
    end
  end
end
