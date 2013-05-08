require 'childprocess'
require 'tempfile'
require 'shellwords'
require 'aruba/errors'

module Aruba
  class SpawnProcess
    include Shellwords

    def initialize(cmd, exit_timeout, io_wait)
      @exit_timeout = exit_timeout
      @io_wait = io_wait

      @cmd = cmd
      @process = nil
      @exit_code = nil
    end

    def run!(&block)
      @process = ChildProcess.build(*shellwords(@cmd))
      @out = Tempfile.new("aruba-out")
      @err = Tempfile.new("aruba-err")
      @process.io.stdout = @out
      @process.io.stderr = @err
      @process.duplex = true
      @exit_code = nil
      begin
        @process.start
      rescue ChildProcess::LaunchError => e
        raise LaunchError.new(e.message)
      end
      yield self if block_given?
    end

    def stdin
      @process.io.stdin
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

    def read_stdout
      wait_for_io do
        @process.io.stdout.flush
        open(@out.path).read
      end
    end

    def stop(reader)
      return @exit_code unless @process
      unless @process.exited?
        @process.poll_for_exit(@exit_timeout)
      end
      reader.stdout stdout
      reader.stderr stderr
      @exit_code = @process.exit_code
      @process = nil
      @out.close
      @err.close
      @exit_code
    end

    def terminate
      if @process
        stdout && stderr # flush output
        @process.stop
        stdout && stderr # flush output
      end
    end

    private

    def wait_for_io(&block)
      sleep @io_wait if @process
      yield
    end

  end
end
