# -*- encoding: utf-8 -*-
lib = ::File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aruba/version'

Gem::Specification.new do |s|
  s.name        = 'aruba'
  s.version     = Aruba::VERSION
  s.author      = "Aslak Hellesøy, Matt Wynne and other Aruba Contributors"
  s.description = 'Extension for popular TDD and BDD frameworks like "Cucumber", "RSpec" and "Minitest" to make testing commandline applications meaningful, easy and fun.'
  s.summary     = "aruba-#{s.version}"
  s.license     = 'MIT'
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = 'http://github.com/cucumber/aruba'

  s.add_runtime_dependency 'cucumber', '~> 2.4.0'
  s.add_runtime_dependency 'childprocess', '~> 0.5.6'
  s.add_runtime_dependency 'ffi', '~> 1.9.10'
  s.add_runtime_dependency 'rspec-expectations', '~> 3.4.0'
  s.add_runtime_dependency 'contracts', '~> 0.14'
  s.add_runtime_dependency 'thor', '~> 0.19'

  s.add_development_dependency 'bundler', '~> 1.11'
  s.rubygems_version = ">= 1.6.1"
  s.required_ruby_version = '>= 1.9.3'

  # s.post_install_message = <<-EOS
  # EOS

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
