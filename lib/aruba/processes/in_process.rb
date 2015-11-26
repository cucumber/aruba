require 'shellwords'
require 'stringio'
require 'aruba/processes/basic_process'
require 'aruba/platform'

# Aruba
module Aruba
  # Platforms
  module Processes
    # Run command in your ruby process
    #
    # `InProcess` is not meant for direct use - `InProcess.new` - by
    # users. Only it's public methods are part of the public API of aruba, e.g.
    # `#stdin`, `#stdout`.
    #
    # @private
    class InProcess < BasicProcess
      # Use only if mode is in_process
      def self.match?(mode)
        mode == :in_process || (mode.is_a?(Class) && mode <= InProcess)
      end

      attr_reader :exit_status

      # Fake Kernel module of ruby
      #
      # @private
      class FakeKernel
        attr_reader :exitstatus

        def initialize
          @exitstatus = 0
        end

        def exit(exitstatus)
          @exitstatus = exitstatus
        end
      end

      class << self
        # @deprecated
        attr_accessor :main_class
      end

      # @private
      attr_reader :main_class

      def initialize(cmd, exit_timeout, io_wait_timeout, working_directory, environment = ENV.to_hash.dup, main_class = nil, stop_signal = nil, startup_wait_time = 0)
        @cmd               = cmd
        @argv              = arguments
        @stdin             = StringIO.new
        @stdout            = StringIO.new
        @stderr            = StringIO.new
        @kernel            = FakeKernel.new

        super
      end

      # Start command
      def start
        fail "You need to call aruba.config.main_class = YourMainClass" unless main_class

        Dir.chdir @working_directory do
          before_run

          Aruba.platform.with_environment environment.merge('PWD' => @working_directory) do
            main_class.new(@argv, @stdin, @stdout, @stderr, @kernel).execute!
          end

          after_run

          yield self if block_given?
        end
      end

      # Stop command
      def stop(*)
        @started     = false
        @exit_status = @kernel.exitstatus
      end

      # Access stdin
      def stdin
        @stdin.string
      end

      # Access stdout
      def stdout(*)
        @stdout.string
      end

      # Access stderr
      def stderr(*)
        @stderr.string
      end

      # Write strint to stdin
      #
      # @param [String] input
      #   Write string to stdin in
      def write(input)
        @stdin.write input
      end

      # Close io
      def close_io(name)
        fail ArgumentError, 'Only stdin stdout and stderr are allowed to close' unless [:stdin, :stdout, :stderr].include? name

        get_instance_variable(name.to_sym).close
      end

      # Terminate program
      def terminate
        stop
      end

      # Output pid of process
      #
      # This is the PID of the ruby process! So be careful
      def pid
        $PROCESS_ID
      end
    end
  end
end
