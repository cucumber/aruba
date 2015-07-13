require 'aruba/processes/spawn_process'
require 'aruba/processes/in_process'
require 'aruba/processes/debug_process'

module Aruba
  class Command < SimpleDelegator
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
        opts.fetch(:main_class)
      )
    rescue KeyError => e
      raise ArgumentError, e.message
    end
  end
end
