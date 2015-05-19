require 'shellwords'
require 'stringio'

module Aruba
  module Processes
    class InProcess
      class FakeKernel
        attr_reader :exitstatus

        def initialize
          @exitstatus = 0
        end

        def exit(exitstatus)
          @exitstatus = exitstatus
        end
      end

      def self.main_class=(main_class)
        @@main_class = main_class
      end

      def initialize(cmd, exit_timeout, io_wait, working_directory)
        args               = Shellwords.split(cmd)
        @argv              = args[1..-1]
        @stdin             = StringIO.new
        @stdout            = StringIO.new
        @stderr            = StringIO.new
        @kernel            = FakeKernel.new
        @working_directory = working_directory
      end

      def run!
        raise "You need to call Aruba::InProcess.main_class = YourMainClass" unless @@main_class

        Dir.chdir @working_directory do
          @@main_class.new(@argv, @stdin, @stdout, @stderr, @kernel).execute!
          yield self if block_given?
        end
      end

      def stop(reader)
        @kernel.exitstatus
      end

      def stdout
        @stdout.string
      end

      def stderr
        @stderr.string
      end
    end
  end
end
