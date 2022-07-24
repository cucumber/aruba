$LOAD_PATH << File.expand_path(__dir__)

require "aruba/platform"

require "bundler"
Bundler.setup

require "cucumber/rake/task"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "yard-junk/rake"

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w(--format progress)
end

Cucumber::Rake::Task.new("cucumber:wip", "Run Cucumber features " \
                                         'which are "WORK IN PROGRESS" and ' \
                                         "are allowed to fail") do |t|
  t.cucumber_opts = %w(--tags @wip:3 --wip)
end

RSpec::Core::RakeTask.new

desc "Run the whole test suite."
task test: [:spec, :cucumber]

RuboCop::RakeTask.new
YardJunk::Rake.define_task

Bundler::GemHelper.install_tasks

require "rake/manifest/task"

Rake::Manifest::Task.new do |t|
  t.patterns = ["lib/**/*", "exe/*", "CHANGELOG.md", "CONTRIBUTING.md",
                "LICENSE", "README.md"]
end

# Check the manifest before building the gem
task build: "manifest:check"

desc "Run checks"
task lint: %w(rubocop manifest:check)

task default: :test
