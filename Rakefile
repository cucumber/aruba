$LOAD_PATH << File.expand_path(__dir__)

require 'aruba/tasks/docker_helpers'
require 'aruba/platform'

require 'bundler'
Bundler.setup

task default: %w(spec cucumber cucumber:wip lint)

desc 'Run all linters.'
task lint: %w(lint:coding_guidelines lint:licenses)

desc 'Run the whole test suite.'
task test: %w(spec cucumber cucumber:wip)

require 'cucumber/rake/task'
require 'rspec/core/rake_task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format progress}
end

Cucumber::Rake::Task.new('cucumber:wip', 'Run Cucumber features '\
                         'which are "WORK IN PROGRESS" and '\
                         'are allowed to fail') do |t|
  t.cucumber_opts = %w{--format progress}
  t.profile = 'wip'
end

RSpec::Core::RakeTask.new

namespace :lint do
  desc 'Lint our code with "rubocop"'
  task :coding_guidelines do
    sh 'bundle exec rubocop --fail-level E'
  end

  desc 'Check for relevant licenses in project'
  task :licenses do
    sh 'bundle exec license_finder'
  end

  require 'yard-junk/rake'
  YardJunk::Rake.define_task
end

Bundler::GemHelper.install_tasks

namespace :docker do
  desc 'Build docker image'
  task :build, :cache, :version do |_, args|
    args.with_defaults(version: 'latest')
    args.with_defaults(cache: true)

    docker_compose_file = Aruba::DockerComposeFile.new(File.expand_path('docker-compose.yml', __dir__))
    docker_run_instance = Aruba::DockerRunInstance.new(docker_compose_file, :base)

    builder = Aruba::DockerBuildCommandLineBuilder.new(
      docker_run_instance,
      cache: args[:cache],
      version: args[:version]
    )

    sh builder.to_cli
  end

  desc 'Run docker container'
  task :run, :command do |_, args|
    docker_compose_file = Aruba::DockerComposeFile.new(File.expand_path('docker-compose.yml', __dir__))
    docker_run_instance = Aruba::DockerRunInstance.new(docker_compose_file, :base)

    builder = Aruba::DockerRunCommandLineBuilder.new(
      docker_run_instance,
      command: args[:command] || docker_run_instance.command
    )

    sh builder.to_cli
  end
end
