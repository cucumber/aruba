require 'aruba'
require 'aruba/spawn_process'
require 'aruba/in_process'
require 'shellwords'
require 'stringio'

class CustomMain
  def initialize(argv, stdin, stdout, stderr, kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
  end

  def execute!
    @stdout.puts(@argv.map{|arg| arg.reverse}.join(' '))
  end
end

Before('@in-process') do
  Aruba::InProcess.main_class = CustomMain
  Aruba.process = Aruba::InProcess
end

After('~@in-process') do
  Aruba.process = Aruba::SpawnProcess
end