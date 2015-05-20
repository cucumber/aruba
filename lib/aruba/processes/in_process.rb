require 'shellwords'
require 'stringio'
require 'aruba/processes/basic_process'

module Aruba
  module Processes
    class InProcess < BasicProcess
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

      def initialize(cmd, exit_timeout, io_wait, working_directory)
        args               = Shellwords.split(cmd)
        @argv              = args[1..-1]
        @stdin             = StringIO.new
        @stdout            = StringIO.new
        @stderr            = StringIO.new
        @kernel            = FakeKernel.new

        super
      end

      def run!
        raise "You need to call Aruba::InProcess.main_class = YourMainClass" unless self.class.main_class

        Dir.chdir @working_directory do
          before_run
          self.class.main_class.new(@argv, @stdin, @stdout, @stderr, @kernel).execute!
          after_run

          yield self if block_given?
        end
      end

      def stop(reader)
        @kernel.exitstatus
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

      def terminate
        stop
      end
    end
  end
end
