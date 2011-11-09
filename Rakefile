# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler::GemHelper.install_tasks

require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  opts = defined?(JRUBY_VERSION) ? %w{--tags ~@jruby} : []
  opts += %w{--tags ~@fails-on-travis} if ENV['TRAVIS']
  t.cucumber_opts = opts 
end

task :default => :cucumber
