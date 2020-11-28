lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cli/app/version'

Gem::Specification.new do |spec|
  spec.name          = 'cli-app'
  spec.version       = Cli::App::VERSION
  spec.authors       = ['Aruba Developers']
  spec.email         = 'cukes@googlegroups.com'

  spec.summary       = 'Summary'
  spec.description   = 'Description'
  spec.homepage      = 'http://example.com'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.

  spec.files         = Dir['lib/**/*', 'README.md']
  spec.bindir        = 'exe'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
