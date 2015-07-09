require 'shellwords'
require 'stringio'
require 'aruba/processes/basic_process'

module Aruba
  module Processes
    class InProcess < BasicProcess
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
        attr_accessor :main_class
      end

      def initialize(cmd, exit_timeout, io_wait, working_directory, environment = ENV.to_hash)
        args               = Shellwords.split(cmd)
        @cmd               = args[0]
        @argv              = args[1..-1]
        @stdin             = StringIO.new
        @stdout            = StringIO.new
        @stderr            = StringIO.new
        @kernel            = FakeKernel.new

        super
      end

      # Return the commandline
      def commandline
        format('%s %s', @cmd, @argv.join(" "))
      end

      def run!
        raise "You need to call Aruba::InProcess.main_class = YourMainClass" unless self.class.main_class

        Dir.chdir @working_directory do
          before_run

          with_environment do
            self.class.main_class.new(@argv, @stdin, @stdout, @stderr, @kernel).execute!
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

      def with_environment(&block)
        old_env = ENV.to_hash

        ENV.update(environment)

        block.call
      ensure
        ENV.clear
        ENV.update old_env
      end
    end
  end
end
