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

    def initialize(command, opts = {})
      launchers = []
      launchers << Processes::DebugProcess
      launchers << Processes::InProcess
      launchers << Processes::SpawnProcess

      launcher = launchers.find { |l| l.match? opts[:mode] }

      super launcher.new(
        command,
        opts.fetch(:exit_timeout),
        opts.fetch(:io_wait_timeout),
        opts.fetch(:working_directory),
        opts.fetch(:environment),
        opts.fetch(:main_class),
        opts.fetch(:stop_signal),
        opts.fetch(:startup_wait_time)
      )

      @event_bus = opts.fetch(:event_bus)
    rescue KeyError => e
      raise ArgumentError, e.message
    end

    # Stop command
    def stop(*)
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
