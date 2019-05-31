lib = ::File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aruba/version'

Gem::Specification.new do |spec|
  spec.name        = 'aruba'
  spec.version     = Aruba::VERSION
  spec.author      = 'Aslak Hellesøy, Matt Wynne and other Aruba Contributors'
  spec.description = 'Extension for popular TDD and BDD frameworks like "Cucumber", "RSpec" and "Minitest" to make testing commandline applications meaningful, easy and fun.'
  spec.summary     = "aruba-#{spec.version}"
  spec.license     = 'MIT'
  spec.email       = 'cukes@googlegroups.com'
  spec.homepage    = 'https://github.com/cucumber/aruba'

  spec.add_runtime_dependency 'childprocess', '~> 1.0'
  spec.add_runtime_dependency 'contracts', '~> 0.13'
  spec.add_runtime_dependency 'cucumber', ['>= 2.4', '< 4.0']
  spec.add_runtime_dependency 'ffi', '~> 1.9'
  spec.add_runtime_dependency 'rspec-expectations', '~> 3.4'
  spec.add_runtime_dependency 'thor', '~> 0.19'

  spec.add_development_dependency 'fuubar', '~> 2.3'
  spec.add_development_dependency 'json', '~> 2.1'
  spec.add_development_dependency 'license_finder', '~> 5.3'
  spec.add_development_dependency 'minitest', '~> 5.10'
  spec.add_development_dependency 'pry-doc', '~> 1.0.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rubocop', '~> 0.69'
  spec.add_development_dependency 'rubocop-performance', '~> 1.1'
  spec.add_development_dependency 'simplecov', '~> 0.15'
  spec.add_development_dependency 'travis-yaml', '~> 0.2'
  spec.add_development_dependency 'yard-junk', '~> 0.0.7'

  spec.rubygems_version = '>= 1.6.1'
  spec.required_ruby_version = '>= 2.3'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.rdoc_options  = ['--charset=UTF-8']
  spec.bindir        = 'exe'
  spec.require_paths = ['lib']
end
