# frozen_string_literal: true

SimpleCov.configure do
  # Activate branch coverage
  enable_coverage :branch

  # ignore this file
  skip '.simplecov'
  skip 'features'

  # Rake tasks aren't tested with rspec
  skip 'Rakefile'
  skip 'lib/tasks'

  #
  # Changed Files in Git Group
  # @see http://fredwu.me/post/35625566267/simplecov-test-coverage-for-changed-files-only
  untracked         = `git ls-files --exclude-standard --others`
  unstaged          = `git diff --name-only`
  staged            = `git diff --name-only --cached`
  all               = untracked + unstaged + staged
  changed_filenames = all.split("\n")

  group 'Changed' do |source_file|
    changed_filenames.select do |changed_filename|
      source_file.filename.end_with?(changed_filename)
    end
  end

  group 'Libraries', 'lib'

  # Specs are reported on to ensure that all examples are being run and all
  # lets, befores, afters, etc are being used.
  group 'Specs', 'spec/'
end
