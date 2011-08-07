# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'aruba'
  s.version     = '0.4.3'
  s.authors     = ["Aslak Hellesøy", "David Chelimsky", "Mike Sassak"]
  s.description = 'CLI Steps for Cucumber, hand-crafted for you in Aruba'
  s.summary     = "aruba-#{s.version}"
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = 'http://github.com/aslakhellesoy/aruba'

  s.add_dependency 'cucumber', '>= 1.0.2'
  s.add_dependency 'childprocess', '>= 0.2.0'
  s.add_dependency 'rspec', '>= 2.6.0'
  s.add_dependency 'bcat', '>= 0.6.1'
  s.add_dependency 'rdiscount', '>= 1.6.8'
  s.add_development_dependency 'rake', '>= 0.9.2'

  s.rubygems_version = ">= 1.6.1"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end

