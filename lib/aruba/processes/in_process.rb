require 'shellwords'
require 'stringio'
require 'aruba/processes/basic_process'

module Aruba
  module Processes
    class InProcess < BasicProcess
      # Use only if mode is in_process
      def self.match?(mode)
        mode == :in_process || (mode.is_a?(Class) && mode <= InProcess)
      end

      attr_reader :exit_status

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

      attr_reader :main_class

      def initialize(cmd, exit_timeout, io_wait, working_directory, environment = ENV.to_hash, main_class = nil)
        @cmd               = cmd
        @argv              = arguments
        @stdin             = StringIO.new
        @stdout            = StringIO.new
        @stderr            = StringIO.new
        @kernel            = FakeKernel.new

        super
      end

      def run!
        fail "You need to call aruba.config.main_class = YourMainClass" unless main_class

        Dir.chdir @working_directory do
          before_run

          in_environment 'PWD' => @working_directory do
            main_class.new(@argv, @stdin, @stdout, @stderr, @kernel).execute!
          end

          after_run

          yield self if block_given?
        end
      end

      def stop(reader)
        @stopped     = true
        @exit_status = @kernel.exitstatus
      end

      def stdin
        @stdin.string
      end

      def stdout
        @stdout.string
      end

      def stderr
        @stderr.string
      end

      def write(input)
        @stdin.write input
      end

      def close_io(name)
        fail ArgumentError, 'Only stdin stdout and stderr are allowed to close' unless [:stdin, :stdout, :stderr].include? name

        get_instance_variable(name.to_sym).close
      end

      def terminate
        stop
      end

      private

      def in_environment(env = {}, &block)
        if RUBY_VERSION <= '1.9.3'
          old_env = ENV.to_hash
        else
          old_env = ENV.to_h
        end

        ENV.update(environment).update(env)

        block.call if block_given?
      ensure
        ENV.clear
        ENV.update old_env
      end
    end
  end
end
