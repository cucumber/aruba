require 'childprocess'
require 'tempfile'
require 'shellwords'

module Aruba
  class Process
    include Shellwords

    def initialize(cmd, exit_timeout, io_wait)
      @exit_timeout = exit_timeout
      @io_wait = io_wait

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
        @process.io.stdin.sync = true
        @process.io.stdin
      end
    end

    def output
      stdout + stderr
    end

    def stdout
      wait_for_io do
        @out.rewind
        remove_ansi_escapes(@out.read)
      end
    end

    def stderr
      wait_for_io do
        @err.rewind
        remove_ansi_escapes(@err.read)
      end
    end

    def stop
      if @process
        stdout && stderr # flush output
        @process.poll_for_exit(@exit_timeout)
        @process.exit_code
      end
    end

    private

    def wait_for_io(&block)
      sleep @io_wait if @process.alive?
      yield
    end

    def remove_ansi_escapes(out)
      out.gsub(/\e\[\d+(?>(;\d+)*)m/, '')
      out
    end
  end
end
