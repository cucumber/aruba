# -*- encoding: utf-8 -*-
require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.version = "0.2.0"
    gem.name = "aruba"
    gem.summary = %Q{CLI Steps for Cucumber}
    gem.description = %Q{CLI Steps for Cucumber, hand-crafted for you in Aruba}
    gem.email = "cukes@googlegroups.com"
    gem.homepage = "http://github.com/aslakhellesoy/aruba"
    gem.authors = ["Aslak Hellesøy", "David Chelimsky"]
    gem.add_development_dependency "rspec", ">= 2.0.0.beta.15"
    gem.add_development_dependency "cucumber", ">= 0.8.2"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = %w{--tags ~@jruby} unless defined?(JRUBY_VERSION)
    t.rcov = true
  end

  task :cucumber => :check_dependencies
rescue LoadError
  task :cucumber do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :cucumber

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "aruba #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
