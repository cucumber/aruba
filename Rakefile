# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler::GemHelper.install_tasks

require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  opts = []
  opts += %w{--tags ~@fails-on-travis} if ENV['TRAVIS']
  t.cucumber_opts = opts 
end

require 'rspec/core/rake_task'
desc "Run RSpec"
RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--color', '--format nested']
end

desc "Run tests, both RSpec and Cucumber"
task :test => [:spec, :cucumber]

task :default => :test
