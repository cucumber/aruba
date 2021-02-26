$LOAD_PATH << File.expand_path(__dir__)

require "aruba/platform"

require "bundler"
Bundler.setup

require "cucumber/rake/task"
require "rspec/core/rake_task"

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w(--format progress)
end

Cucumber::Rake::Task.new("cucumber:wip", "Run Cucumber features "\
                         'which are "WORK IN PROGRESS" and '\
                         "are allowed to fail") do |t|
  t.cucumber_opts = %w(--format progress)
  t.profile = "wip"
end

RSpec::Core::RakeTask.new

desc "Run the whole test suite."
task test: [:spec, :cucumber]

namespace :lint do
  desc 'Lint our code with "rubocop"'
  task :coding_guidelines do
    sh "bundle exec rubocop"
  end

  desc "Check for relevant licenses in project"
  task :licenses do
    sh "bundle exec license_finder"
  end

  require "yard-junk/rake"
  YardJunk::Rake.define_task
end

desc "Run all linters."
task lint: %w(lint:coding_guidelines lint:licenses)

Bundler::GemHelper.install_tasks

begin
  require "rake/manifest/task"

  Rake::Manifest::Task.new do |t|
    t.patterns = ["lib/**/*", "exe/*", "CHANGELOG.md", "CONTRIBUTING.md",
                  "LICENSE", "README.md"]
  end

  # Check the manifest before building the gem
  task build: "manifest:check"

  # Also check the manifest as part of the linting
  task lint: "manifest:check"
rescue LoadError
  # skip
end

task default: :test
