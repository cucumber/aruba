# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'aruba'
  s.version     = '0.3.2.1'
  s.authors     = ["Aslak Hellesøy", "David Chelimsky", "Mike Sassak"]
  s.description = 'CLI Steps for Cucumber, hand-crafted for you in Aruba'
  s.summary     = "aruba-#{s.version}"
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = 'http://github.com/aslakhellesoy/aruba'

  s.add_dependency 'cucumber', '~> 0.10'
  s.add_dependency 'childprocess', '~> 0.1.7'
  s.add_dependency 'rspec', '~> 2.5'

  s.rubygems_version   = ">= 1.6.1"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = ["LICENSE", "README.rdoc", "History.txt"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end

