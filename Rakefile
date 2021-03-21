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

  require "yard-junk/rake"
  YardJunk::Rake.define_task
end

desc "Run all linters."
task lint: %w(lint:coding_guidelines)

# Also check the manifest as part of the linting
task lint: "manifest:check"

Bundler::GemHelper.install_tasks

require "rake/manifest/task"

Rake::Manifest::Task.new do |t|
  t.patterns = ["lib/**/*", "exe/*", "CHANGELOG.md", "CONTRIBUTING.md",
                "LICENSE", "README.md"]
end

task build: "manifest:check"

task default: :test
