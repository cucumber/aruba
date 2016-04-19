$LOAD_PATH << File.expand_path('../', __FILE__)

require 'bundler'
Bundler.setup

task :default => :test

desc 'Run the whole test suite. Any failure will stop rake going on'
task :test => %w(lint:travis lint:rubocop test:rspec test:cucumber test:cucumber_wip)

task :cucumber do
  $stderr.puts '[DEPRECATED] The use of task "cucumber" is deprecated. Please use "test:cucumber"'
  Rake::Task['test:cucumber'].invoke
end

task :cucumber_wip do
  $stderr.puts '[DEPRECATED] The use of task "cucumber_wip" is deprecated. Please use "test:cucumber_wip"'
  Rake::Task['test:cucumber_wip'].invoke
end

task :spec do
  $stderr.puts '[DEPRECATED] The use of task "spec" is deprecated. Please use "test:rspec"'
  Rake::Task['test:rspec'].invoke
end

task :rubocop do
  $stderr.puts '[DEPRECATED] The use of task "rubocop" is deprecated. Please use "lint:rubocop"'
  Rake::Task['test:rubocop'].invoke
end

namespace :test do
  desc 'Run cucumber tests'
  task :cucumber do
    sh 'cucumber'
  end

  desc 'Run cucumber tests which are "WORK IN PROGRESS" and are allowed to fail'
  task :cucumber_wip do
    sh 'cucumber -p wip'
  end

  desc 'Run rspec tests'
  task :rspec do
    sh 'rspec'
  end
end

namespace :lint do
  desc 'Lint our .travis.yml'
  task :travis do
    begin
      require 'travis/yaml'

      puts 'Linting .travis.yml ... No output is good!'
      Travis::Yaml.parse! File.read('.travis.yml')
    rescue LoadError => e
      $stderr.puts "You ruby is not supported for linting the .travis.yml: #{e.message}"
    end
  end

  desc 'Lint our code with "rubocop"'
  task :rubocop do
    begin
      sh 'rubocop --fail-level E'
    rescue
    end
  end
end


namespace :rubygem do
  Bundler::GemHelper.install_tasks
end

namespace :docker do
  Psych.load_file('docker-compose.yml')['services']

  desc 'Build docker image'
  task :build, :nocache, :version do |_, args|
    args.with_defaults(:version => 'latest')
    args.with_defaults(:cache => true)

    docker_compose_configuration = Psych.load_file(@opts[:dockerfile])['services']

    nocache             = args[:nocache]
    application_version = args[:version]
    docker_file         = docker_compose_configuration[:dockerfile]

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
