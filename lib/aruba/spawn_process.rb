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
      @output_cache = nil
      @error_cache = nil
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
      wait_for_io { read(@out) } || @output_cache
    end

    def stderr
      wait_for_io { read(@err) } || @error_cache
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
      @exit_code = @process.exit_code
      @process = nil
      close_and_cache_out
      close_and_cache_err
      if reader
        reader.stdout stdout
        reader.stderr stderr
      end
      @exit_code
    end

    def terminate
      if @process
        @process.stop
        stop nil
      end
    end

    private

    def wait_for_io(&block)
      if @process
        sleep @io_wait
        yield
      end
    end

    def read(io)
      io.rewind
      io.read
    end

    def close_and_cache_out
      @output_cache = read @out
      @out.close
      @out = nil
    end

    def close_and_cache_err
      @error_cache = read @err
      @err.close
      @err = nil
    end

  end
end
