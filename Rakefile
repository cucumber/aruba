$LOAD_PATH << File.expand_path('../', __FILE__)

require 'aruba/tasks/docker_helpers'
require 'aruba/platform'

require 'bundler'
Bundler.setup

task default: [:lint, :test]

desc 'Run all linters.'
task test: %w(lint:travis lint:coding_guidelines lint:licenses)

desc 'Run the whole test suite.'
task test: %w(test:rspec test:cucumber test:cucumber_wip)

require 'cucumber/rake/task'
require 'rspec/core/rake_task'

namespace :test do
  Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = %w{--format progress}
  end

  Cucumber::Rake::Task.new(:cucumber_wip, 'Run Cucumber features '\
                           'which are "WORK IN PROGRESS" and '\
                           'are allowed to fail') do |t|
    t.cucumber_opts = %w{--format progress}
    t.profile = 'wip'
  end

  desc 'Run RSpec tests'
  RSpec::Core::RakeTask.new(:rspec)
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
  task :coding_guidelines do
    if RUBY_VERSION >= '2'
      sh 'bundle exec rubocop --fail-level E'
    else
      warn 'Your ruby version is not supported for code linting'
    end
  end

  desc 'Check for relevant licenses in project'
  task :licenses do
    sh 'bundle exec license_finder'
  end

  begin
    require 'yard-junk/rake'
    YardJunk::Rake.define_task
  rescue LoadError
    warn 'yard-junk requires Ruby 2.3.0. Rake task lint:yard:junk not loaded.'
  end
end

namespace :rubygem do
  Bundler::GemHelper.install_tasks
end

namespace :docker do
  desc 'Build docker image'
  task :build, :cache, :version do |_, args|
    args.with_defaults(version: 'latest')
    args.with_defaults(cache: true)

    docker_compose_file = Aruba::DockerComposeFile.new(File.expand_path('../docker-compose.yml', __FILE__))
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
    docker_compose_file = Aruba::DockerComposeFile.new(File.expand_path('../docker-compose.yml', __FILE__))
    docker_run_instance = Aruba::DockerRunInstance.new(docker_compose_file, :base)

    builder = Aruba::DockerRunCommandLineBuilder.new(
      docker_run_instance,
      command: args[:command] || docker_run_instance.command
    )

    sh builder.to_cli
  end
end
