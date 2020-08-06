lib = ::File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aruba/version'
require 'rake/file_list'

Gem::Specification.new do |spec|
  spec.name        = 'aruba'
  spec.version     = Aruba::VERSION
  spec.author      = 'Aslak Hellesøy, Matt Wynne and other Aruba Contributors'
  spec.description = <<~TEXT
    Extension for popular TDD and BDD frameworks like "Cucumber", "RSpec" and "Minitest",
    to make testing commandline applications meaningful, easy and fun.
  TEXT
  spec.summary     = "aruba-#{spec.version}"
  spec.license     = 'MIT'
  spec.email       = 'cukes@googlegroups.com'
  spec.homepage    = 'https://github.com/cucumber/aruba'

  spec.metadata    = {
    'bug_tracker_uri' => 'https://github.com/cucumber/aruba/issues',
    'changelog_uri' => 'https://www.rubydoc.info/gems/aruba/file/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/aruba',
    'homepage_uri' => spec.homepage,
    'source_code_uri' => 'https://github.com/cucumber/aruba'
  }

  spec.add_runtime_dependency 'childprocess', ['>= 2.0', '< 5.0']
  spec.add_runtime_dependency 'contracts', '~> 0.16.0'
  spec.add_runtime_dependency 'cucumber', ['>= 2.4', '< 5.0']
  spec.add_runtime_dependency 'ffi', '~> 1.9'
  spec.add_runtime_dependency 'rspec-expectations', '~> 3.4'
  spec.add_runtime_dependency 'thor', '~> 1.0'

  spec.add_development_dependency 'json', '~> 2.1'
  spec.add_development_dependency 'license_finder', '~> 6.0'
  spec.add_development_dependency 'minitest', '~> 5.10'
  spec.add_development_dependency 'pry-doc', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rubocop', '~> 0.85'
  spec.add_development_dependency 'rubocop-packaging', '~> 0.2.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.5'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.39'
  spec.add_development_dependency 'simplecov', '~> 0.18.0'
  spec.add_development_dependency 'yard-junk', '~> 0.0.7'

  spec.rubygems_version = '>= 1.6.1'
  spec.required_ruby_version = '>= 2.4'

  spec.files = Rake::FileList['{docs,fixtures,lib}/**/*', 'CHANGELOG.md', \
                              'LICENSE', 'README.md'].exclude(*File.read('.gitignore').split)

  spec.executables      = ['aruba']
  spec.rdoc_options     = ['--charset', 'UTF-8', '--main', 'README.md']
  spec.extra_rdoc_files = ['CHANGELOG.md', 'CONTRIBUTING.md', 'README.md', 'LICENSE']
  spec.bindir           = 'exe'
  spec.require_paths    = ['lib']
end
