# frozen_string_literal: true

require 'aruba/platform'
require 'shellwords'

# Aruba
module Aruba
  # Processes
  module Processes
    # Basic Process
    #
    # `BasicProcess` is not meant for direct use - `BasicProcess.new` - by users.
    #
    # @private
    class BasicProcess
      attr_reader :exit_status, :environment, :working_directory, :main_class,
                  :io_wait_timeout, :exit_timeout, :startup_wait_time, :stop_signal

      def initialize(cmd, exit_timeout, io_wait_timeout, working_directory, # rubocop:disable Metrics/ParameterLists
                     environment = Aruba.platform.environment_variables.hash_from_env,
                     main_class = nil, stop_signal = nil, startup_wait_time = 0)
        @cmd               = cmd
        @working_directory = working_directory
        @environment       = environment
        @main_class        = main_class
        @exit_status       = nil
        @stop_signal       = stop_signal
        @startup_wait_time = startup_wait_time

        @exit_timeout    = exit_timeout
        @io_wait_timeout = io_wait_timeout

        @started         = false
        @timed_out       = false
      end

      # Return command line
      def commandline
        @cmd
      end

      # Output pid of process
      def pid
        raise NotImplementedError
      end

      # Output stderr and stdout
      def output(opts = {})
        stdout(opts) + stderr(opts)
      end

      def write(*)
        raise NotImplementedError
      end

      def stdin(*)
        raise NotImplementedError
      end

      def stdout(*)
        raise NotImplementedError
      end

      def stderr(*)
        raise NotImplementedError
      end

      def close_io(*)
        raise NotImplementedError
      end

      def send_signal(*)
        raise NotImplementedError
      end

      def filesystem_status
        raise NotImplementedError
      end

      def content
        raise NotImplementedError
      end

      def wait
        raise NotImplementedError
      end

      # Restart a command
      def restart
        stop
        start
      end

      # Was process already stopped
      def stopped?
        @started == false
      end

      # Was process already started
      def started?
        @started == true
      end

      # Does the process failed to stop in time
      def timed_out?
        @timed_out == true
      end

      # Hook which is run before command is run
      def before_run; end

      # Hook which is run after command is run
      def after_run; end

      def inspect
        out = truncate(stdout(wait_for_io: 0).inspect, 35)
        err = truncate(stderr(wait_for_io: 0).inspect, 35)

        fmt = '#<%s:%s commandline="%s": stdout=%s stderr=%s>'
        format fmt, self.class, object_id, commandline, out, err
      end

      alias to_s inspect

      def command
        Shellwords.split(commandline).first
      end

      def arguments
        return Shellwords.split(commandline)[1..] if Shellwords.split(commandline).size > 1

        []
      end

      def empty?
        false
      end

      private

      def truncate(string, max_length)
        return string if string.length <= max_length

        "#{string[0, max_length - 1]} ..."
      end
    end
  end
end
