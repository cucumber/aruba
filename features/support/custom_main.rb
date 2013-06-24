require 'aruba'
require 'aruba/spawn_process'
require 'aruba/in_process'
require 'shellwords'
require 'stringio'
require 'thor'

class CustomMain
  def initialize(argv, stdin, stdout, stderr, kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
  end

  def execute!
    $stdin  = @stdin
    $stdout = @stdout
    $stderr = @stderr

    Cli.start(@argv)
    @kernel.exit(0)
  end
end

class Cli < Thor
  desc 'reverse', 'Reverse the given string args'
  def reverse(*args)
    puts args.map(&:reverse).join(' ')
  end

  desc 'mimic', 'Say what I say'
  def minic
    sentence = gets.chomp
    puts sentence
  end
end

Before('@in-process') do
  Aruba::InProcess.main_class = CustomMain
  Aruba.process = Aruba::InProcess
end

After('~@in-process') do
  Aruba.process = Aruba::SpawnProcess
end
