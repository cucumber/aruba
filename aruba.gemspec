# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'aruba'
  s.version     = '0.6.2'
  s.authors     = ["Aslak Hellesøy", "David Chelimsky", "Mike Sassak", "Matt Wynne"]
  s.description = 'CLI Steps for Cucumber, hand-crafted for you in Aruba'
  s.summary     = "aruba-#{s.version}"
  s.license     = 'MIT'
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = 'http://github.com/cucumber/aruba'

  s.add_runtime_dependency 'cucumber', '>= 1.1.1'
  s.add_runtime_dependency 'childprocess', '>= 0.3.6'
  s.add_runtime_dependency 'rspec-expectations', '>= 2.7.0'
  s.add_runtime_dependency 'contracts', '~> 0.9'

  s.add_development_dependency 'bundler', '~> 1.10.2'

  s.rubygems_version = ">= 1.6.1"
  # s.required_ruby_version = '>= 2.0'
  s.post_install_message = 'From aruba > 2.0 ruby 1.9.3-support is discontinued'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
