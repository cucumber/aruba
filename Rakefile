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

require 'uri'
namespace :docker do
  image_name          = 'cucumber/aruba'
  container_name      = 'cucumber-aruba-1'

  desc 'Build docker image'
  task :build, :nocache, :version do |_, args|
    args.with_defaults(version: 'latest')

    nocache        = args[:nocache]
    application_version = args[:version]
    docker_file = 'Dockerfile'

    cmdline = []
    cmdline << 'docker'
    cmdline << 'build'
    cmdline << '--no-cache=true' if nocache == 'true'

    %w(http_proxy https_proxy HTTP_PROXY HTTPS_PROXY).each do |var|
      next unless ENV.key? var

      proxy_uri = URI(ENV[var])
      proxy_uri.host = '172.17.0.1'
      cmdline << "--build-arg #{var}=#{proxy_uri}"
    end

    cmdline << "-t #{image_name}:#{application_version}"
    cmdline << "-f #{docker_file}"
    cmdline << File.dirname(docker_file)

    sh cmdline.join(' ')
  end

  desc 'Run docker container'
  task :run, :command do |_, task_args|
    command = task_args[:command]

    args =[]
    args << '-it'
    args << '--rm'
    args << "--name #{container_name}"
    args << "-v #{File.expand_path('.')}:/srv/app"

    cmdline = []
    cmdline << 'docker'
    cmdline << 'run'
    cmdline.concat args
    cmdline << image_name
    cmdline << command if command

    sh cmdline.join(' ')
  end
end
