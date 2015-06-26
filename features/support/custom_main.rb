require 'aruba'
require 'aruba/processes/spawn_process'
require 'aruba/processes/in_process'
require 'shellwords'
require 'stringio'

class CustomMain
  def initialize(argv, stdin, stdout, stderr, kernel)
    @argv   = argv
    @stdin  = stdin
    @stdout = stdout
    @stderr = stderr
    @kernel = kernel
  end

  def execute!
    @stdout.puts(@argv.map(&:reverse).join(' '))
  end
end

Before('@in-process') do
  Aruba.process = Aruba::Processes::InProcess
  Aruba.process.main_class = CustomMain
end

After('~@in-process') do
  Aruba.process = Aruba::Processes::SpawnProcess
end
