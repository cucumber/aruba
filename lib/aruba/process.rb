require 'background_process'
require 'childprocess'
require 'tempfile'

module Aruba
  class Process
    def initialize(cmd, timeout)
      #@cmd = cmd
      @timeout = timeout

      @out = Tempfile.new("aruba-out")
      @err = Tempfile.new("aruba-err")

      @process = ChildProcess.build(cmd)
      @process.io.stdout = @out
      @process.io.stderr = @err
    end

    def run!(&block)
      @process.start
      @process.poll_for_exit(10)
      #@process = BackgroundProcess.run(@cmd)
      yield self if block_given?
    end

    def stdin
      @process.io.stdin
    end

    def output
      stdout + stderr
    end

    def stdout
      @out.rewind
      if @process
        @stdout ||= @out.read
      else
        ''
      end
    end

    def stderr
      @err.rewind
      if @process
        @stderr ||= @err.read
      else
        ''
      end
    end

    def stop
      if @process
        #status = @process.wait(@timeout)
        #status && status.exitstatus
        @process.stop(@timeout)
        @process.exit_code
      end
    end
  end
end
