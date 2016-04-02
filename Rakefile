# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler::GemHelper.install_tasks

require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = ""
  # t.cucumber_opts = "--format Cucumber::Pro --out cucumber-pro.log" if ENV['CUCUMBER_PRO_TOKEN']
  t.cucumber_opts << "--format pretty"
end

Cucumber::Rake::Task.new(:cucumber_wip) do |t|
  t.cucumber_opts = "-p wip"
end

require 'rspec/core/rake_task'
desc "Run RSpec"
RSpec::Core::RakeTask.new do |spec|
  spec.rspec_opts = ['--color', '--format documentation', '--warnings']
end

namespace :travis do
  desc 'Lint travis.yml'
  task :lint do
    begin
      require 'travis/yaml'

      puts 'Linting .travis.yml ... No output is good!'
      Travis::Yaml.parse! File.read('.travis.yml')
    rescue LoadError
      $stderr.puts 'You ruby is not supported for linting the .travis.yml'
    end
  end
end

task :rubocop do
  begin
    sh 'rubocop --fail-level E'
  rescue
  end
end

desc "Run tests, both RSpec and Cucumber"
task :test => [ 'travis:lint', :rubocop, :spec, :cucumber, :cucumber_wip]

task :default => :test

require 'yaml'
namespace :docker do
  config = YAML.load(IO.read('docker-compose.yml'))['services']

  def build_image(config, options)
    build_options = config['build']
    application_version = options.delete(:version)
    nocache = options.delete(:nocache)

    cmdline = %W(docker build --no-cache=#{nocache})

    build_options['args'].each do |key, value|
      cmdline << "--build-arg #{key}=#{value}"
    end

    cmdline << "-t #{config['image']}:#{application_version}"
    cmdline << "-f #{build_options['dockerfile']}"
    cmdline << build_options['context']
    sh cmdline.join(' ')
  end

  def expand_volume_paths(volume_paths)
    volume_paths.split(':').map { |path| File.expand_path(path) }.join(':')
  end

  def run_container(config, command)
    cmdline = %W(docker run -it --rm --name #{config['container_name']} -w #{config['working_dir']})

    volumes = config['volumes'].map { |volume| expand_volume_paths(volume) }
    volumes.each { |volume| cmdline << "-v #{volume}" }

    cmdline << config['image']
    cmdline << (command ? command : config['command'])

    puts "Running Docker with arguments:"
    puts cmdline.inspect

    sh cmdline.join(' ')
  end

  desc 'Build docker base image'
  task :build, :nocache, :version do |_, args|
    args.with_defaults(:version => 'latest')
    args.with_defaults(:nocache => 'false')
    build_image(config['base'], version: args[:version], nocache: args[:nocache])
  end

  desc 'Run docker container'
  task :run, :command do |_, task_args|
    tests = config['tests']

    puts "Building/updating test image"
    build_image(tests, version: 'test', nocache: 'false')

    command = task_args[:command]
    command = "bash -l -c #{Shellwords.escape(command)}" if command

    run_container(tests, command)
  end
end
