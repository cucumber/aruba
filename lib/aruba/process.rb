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
      sleep 0.1
      @process.io.stdin
    end

    def output
      stdout + stderr
    end

    def stdout
      sleep 0.1
      @out.rewind
      @out.read
    end

    def stderr
      sleep 0.1
      @err.rewind
      @err.read
    end

    def stop
      if @process
        stdout && stderr # flush output
        @process.poll_for_exit(@timeout)
        @process.exit_code
      end
    end
  end
end
