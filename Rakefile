# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler::GemHelper.install_tasks

require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = ""
  t.cucumber_opts << "--format progress"
end

Cucumber::Rake::Task.new(:cucumber_wip) do |t|
  t.cucumber_opts = "-p wip"
end

require 'rspec/core/rake_task'
desc "Run RSpec"
RSpec::Core::RakeTask.new do |spec|
  spec.rspec_opts = ['--color', '--format progress', '--warnings']
end

namespace :travis do
  desc 'Lint travis.yml'
  task :lint do
    begin
      require 'travis/yaml'

      puts 'Linting .travis.yml ... No output is good!'
      Travis::Yaml.parse! File.read('.travis.yml')
    rescue LoadError
      $stderr.puts 'Your ruby is not supported for linting the .travis.yml file'
    end
  end
end

task :rubocop do
  if RUBY_VERSION >= '2'
    sh 'bundle exec rubocop --fail-level E'
  else
    warn 'Your ruby version is not supported for code linting'
  end
end

desc "Run tests, both RSpec and Cucumber"
task :test => [ 'travis:lint', :rubocop, :spec, :cucumber, :cucumber_wip]

task :default => :test
