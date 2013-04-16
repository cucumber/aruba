require 'aruba'
require 'aruba/process'
require 'shellwords'
require 'stringio'

class Reverse
  def initialize(argv, stdout)
    @argv = argv
    @stdout = stdout
  end

  def doit
    @stdout.puts(@argv.map{|arg| arg.reverse}.join(' '))
  end
end

class ReversingProcess
  include Shellwords

  def initialize(cmd, exit_timeout, io_wait)
    args = shellwords(cmd)
    raise "I can only run reverse" unless args[0] == 'reverse'

    @stdout = StringIO.new
    @reverse = Reverse.new(args[1..-1], @stdout)
  end

  def run!(&block)
    @reverse.doit
    yield self if block_given?
  end

  def stop(reader)
    0
  end

  def stdout
    @stdout.string
  end

  def stderr
    ""
  end
end

Before('@custom-reversing-process') do
  Aruba.process = ReversingProcess
end

After('@custom-reversing-process') do
  Aruba.process = Aruba::Process
end