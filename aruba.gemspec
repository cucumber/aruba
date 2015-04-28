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
  s.add_development_dependency 'bcat', '>= 0.6.1'
  s.add_development_dependency 'kramdown', '>= 0.14'
  s.add_development_dependency 'rake', '>= 0.9.2'
  s.add_development_dependency 'rspec', '>= 3.0.0'
  s.add_development_dependency 'fuubar', '>= 1.1.1'
  s.add_development_dependency 'cucumber-pro', '~> 0.0'
  s.add_development_dependency 'rubocop', '~> 0.26.0'

  s.add_development_dependency 'pry', '~> 0.10.1 '
  s.add_development_dependency 'byebug', '~> 4.0.5'
  s.add_development_dependency 'pry-byebug', '~> 3.1.0'
  s.add_development_dependency 'pry-stack_explorer', '~> 0.4.9'
  s.add_development_dependency 'pry-doc', '~> 0.6.0'

  s.add_development_dependency 'license_finder', '~> 2.0.4'

  s.rubygems_version = ">= 1.6.1"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
