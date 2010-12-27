require 'childprocess'
require 'tempfile'
require 'shellwords'

module Aruba
  class Process
    include Shellwords

    def initialize(cmd, timeout)
      @timeout = timeout
      @out = Tempfile.new("aruba-out")
      @err = Tempfile.new("aruba-err")
      @process = ChildProcess.build(*shellwords(cmd))
      @process.io.stdout = @out
      @process.io.stderr = @err
      @process.duplex = true
    end

    def run!(&block)
      @process.start
      yield self if block_given?
    end

    def stdin
      wait_for_io do
        @process.io.stdin
      end
    end

    def output
      stdout + stderr
    end

    def stdout
      wait_for_io do
        @out.rewind
        @out.read
      end
    end

    def stderr
      wait_for_io do
        @err.rewind
        @err.read
      end
    end

    def stop
      if @process
        stdout && stderr # flush output
        @process.poll_for_exit(@timeout)
        @process.exit_code
      end
    end

    private

    def wait_for_io(&block)
      sleep 0.1 if @process.alive?
      yield
    end
  end
end
