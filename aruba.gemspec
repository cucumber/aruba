# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'aruba'
  s.version     = '0.8.0'
  s.authors     = ["Aslak Hellesøy", "David Chelimsky", "Mike Sassak", "Matt Wynne", "Jarl Friis", "Dennis Günnewig"]
  s.description = 'Extension for popular TDD and BDD frameworks like "Cucumber" and "RSpec" to make testing commandline applications meaningful, easy and fun.'
  s.summary     = "aruba-#{s.version}"
  s.license     = 'MIT'
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = 'http://github.com/cucumber/aruba'

  s.add_runtime_dependency 'cucumber', '>= 1.3.19'
  s.add_runtime_dependency 'childprocess', '~> 0.5.6'
  s.add_runtime_dependency 'rspec-expectations', '>= 2.99'
  s.add_runtime_dependency 'contracts', '~> 0.9'

  s.add_development_dependency 'bundler', '~> 1.10.2'

  s.rubygems_version = ">= 1.6.1"
  s.required_ruby_version = '>= 1.8.7'
  s.post_install_message = <<-EOS
Use on ruby 1.8.7
* Make sure you add something like that to your `Gemfile`. Otherwise you will
  get cucumber > 2 and this will fail on ruby 1.8.7

  gem 'cucumber', ~> '1.3.20'

With aruba >= 1.0
  * "ruby 1.8.7"-support is discontinued.
  * aruba requires "cucumber 2" for the feature steps. The rest of aruba should
    be usable by whatever testing framework you are using.
  * Overwriting methods for configuration is discontinued. You need to use
    `aruba.config.<variable>` or `Aruba.configure { |config| config.<variable>`
    instead.
  * "aruba/reporting" will be removed. Please use `@debug`-tag + `byebug`,
    `debugger`, `pry` to troubleshoot your feature tests.
  * Set environment variables will have only effect on `#run` and the like +
    `#with_environment { }`.
  * The process environment will be fully resetted between tests. Sharing state
    via ENV['VAR'] = 'shared state' between tests will not be possible anymore.
    Please make that obvious by using explicit steps or use the aruba API for
    that.
  * There will be a major cleanup for command execution. There will be only
    `run` and `run_simple` left. `run_interactive` is replaced by `run`.
  * Setting the root directory of aruba via method overwrite or configuration -
    this should be your project root directory where the test suite is run.
  * The direct use of "InProcess", "DebugProcess" and "SpawnProcess" is not
    supported anymore. You need to use "Command" instead. But be careful, it has
    a different API.
EOS

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
