require_relative "lib/aruba/version"

Gem::Specification.new do |spec|
  spec.name        = "aruba"
  spec.version     = Aruba::VERSION
  spec.author      = "Aslak Hellesøy, Matt Wynne and other Aruba Contributors"
  spec.description = <<~TEXT
    Extension for popular TDD and BDD frameworks like "Cucumber", "RSpec" and "Minitest",
    to make testing command line applications meaningful, easy and fun.
  TEXT
  spec.summary     = "aruba-#{spec.version}"
  spec.license     = "MIT"
  spec.email       = "cukes@googlegroups.com"
  spec.homepage    = "https://github.com/cucumber/aruba"

  spec.metadata    = {
    "bug_tracker_uri" => "https://github.com/cucumber/aruba/issues",
    "changelog_uri" => "https://www.rubydoc.info/gems/aruba/file/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/aruba",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/cucumber/aruba"
  }

  spec.add_runtime_dependency "bundler", [">= 1.17", "< 3.0"]
  spec.add_runtime_dependency "childprocess", [">= 2.0", "< 5.0"]
  spec.add_runtime_dependency "contracts", [">= 0.16.0", "< 0.18.0"]
  spec.add_runtime_dependency "cucumber", ">= 4.0", "< 8.0"
  spec.add_runtime_dependency "rspec-expectations", "~> 3.4"
  spec.add_runtime_dependency "thor", "~> 1.0"

  spec.add_development_dependency "appraisal", "~> 2.4"
  spec.add_development_dependency "json", "~> 2.1"
  spec.add_development_dependency "kramdown", "~> 2.1"
  spec.add_development_dependency "minitest", "~> 5.10"
  spec.add_development_dependency "pry", [">= 0.13.0", "< 0.15.0"]
  spec.add_development_dependency "pry-doc", "~> 1.0"
  spec.add_development_dependency "rake", [">= 12.0", "< 14.0"]
  spec.add_development_dependency "rake-manifest", "~> 0.2.0"
  spec.add_development_dependency "rspec", "~> 3.10.0"
  spec.add_development_dependency "rubocop", "~> 1.24.0"
  spec.add_development_dependency "rubocop-packaging", "~> 0.5.0"
  spec.add_development_dependency "rubocop-performance", "~> 1.13.0"
  spec.add_development_dependency "rubocop-rspec", "~> 2.7.0"
  spec.add_development_dependency "simplecov", [">= 0.18.0", "< 0.22.0"]
  spec.add_development_dependency "yard-junk", "~> 0.0.7"

  spec.rubygems_version = ">= 1.6.1"
  spec.required_ruby_version = ">= 2.5"

  spec.files = File.readlines("Manifest.txt", chomp: true)

  spec.executables      = ["aruba"]
  spec.rdoc_options     = ["--charset", "UTF-8", "--main", "README.md"]
  spec.extra_rdoc_files = ["CHANGELOG.md", "CONTRIBUTING.md", "README.md", "LICENSE"]
  spec.bindir           = "exe"
  spec.require_paths    = ["lib"]
end
