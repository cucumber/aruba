require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.version = "0.1"
    gem.name = "aruba"
    gem.summary = %Q{CLI Steps for Cucumber}
    gem.description = %Q{CLI Steps for Cucumber, hand-crafted for you in Aruba}
    gem.email = "cukes@groups.google.com"
    gem.homepage = "http://github.com/aslakhellesoy/aruba"
    gem.authors = ["Aslak Hellesoy", "David Chelimsky"]
    gem.add_development_dependency "rspec", ">= 1.3.0"
    gem.add_development_dependency "cucumber", ">= 0.6.2"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new do |t|
    t.rcov = true
  end

  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "aruba #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
