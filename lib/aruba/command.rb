# frozen_string_literal: true

require 'delegate'
require 'aruba/processes/spawn_process'
require 'aruba/processes/in_process'
require 'aruba/processes/debug_process'

# Aruba
module Aruba
  # Command
  #
  # This class is not meant for direct use - Command.new, though it's API is
  # public. As it is just a wrapper class, have a look at `BasicProcess` and
  # the like for the public API.
  #
  # @see BasicProcess
  # @see SpawnProcess
  #
  # @private
  class Command < SimpleDelegator
    private

    attr_reader :event_bus

    public

    LAUNCHERS = [
      Processes::DebugProcess,
      Processes::InProcess,
      Processes::SpawnProcess
    ].freeze

    def initialize(command, exit_timeout:, io_wait_timeout:, working_directory:, environment:, # rubocop:disable Metrics/ParameterLists
                   main_class:, stop_signal:, startup_wait_time:, event_bus:, mode: nil)
      klass = LAUNCHERS.find { |l| l.match? mode }

      launcher = klass.new(
        command,
        exit_timeout,
        io_wait_timeout,
        working_directory,
        environment,
        main_class,
        stop_signal,
        startup_wait_time
      )

      super(launcher)

      @event_bus = event_bus
    end

    # Stop command
    def stop(*)
      return if __getobj__.stopped?

      __getobj__.stop
      event_bus.notify Events::CommandStopped.new(self)

      self
    end

    # Terminate command
    def terminate(*)
      return if __getobj__.stopped?

      __getobj__.terminate
      event_bus.notify Events::CommandStopped.new(self)

      self
    end

    # Start command
    def start
      __getobj__.start
      event_bus.notify Events::CommandStarted.new(self)

      self
    end
    alias run! start
  end
end
