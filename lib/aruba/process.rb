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

    def output(keep_ansi)
      stdout(keep_ansi) + stderr(keep_ansi)
    end

    def stdout(keep_ansi)
      wait_for_io do
        @out.rewind
        filter_ansi(@out.read, keep_ansi)
      end
    end

    def stderr(keep_ansi)
      wait_for_io do
        @err.rewind
        filter_ansi(@err.read, keep_ansi)
      end
    end

    def read_stdout(keep_ansi)
      wait_for_io do
        @process.io.stdout.flush
        content = filter_ansi(open(@out.path).read, keep_ansi)
      end
    end

    def stop(reader, keep_ansi)
      return unless @process
      unless @process.exited?
        reader.stdout stdout(keep_ansi)
        reader.stderr stderr(keep_ansi)
        @process.poll_for_exit(@exit_timeout)
      end
      @process.exit_code
    end

    def terminate(keep_ansi)
      if @process
        stdout(keep_ansi) && stderr(keep_ansi) # flush output
        @process.stop
        stdout(keep_ansi) && stderr(keep_ansi) # flush output
      end
    end

    private

    def wait_for_io(&block)
      sleep @io_wait if @process.alive?
      yield
    end

    def filter_ansi(string, keep_ansi)
      keep_ansi ? string : string.gsub(/\e\[\d+(?>(;\d+)*)m/, '')
    end

  end
end
