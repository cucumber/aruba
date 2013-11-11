require 'shellwords'
require 'stringio'

module Aruba
  class InProcess
    include Shellwords

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

    def initialize(cmd, exit_timeout, io_wait)
      args = shellwords(cmd)
      @argv = args[1..-1]
      @stdin = StringIO.new
      @stdout = StringIO.new
      @stderr = StringIO.new
      @kernel = FakeKernel.new
    end

    def run!
      raise "You need to call Aruba::InProcess.main_class = YourMainClass" unless @@main_class
      @@main_class.new(@argv, @stdin, @stdout, @stderr, @kernel).execute!
      yield self if block_given?
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