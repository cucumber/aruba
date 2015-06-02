# Run simplecov by default
SimpleCov.start unless ENV.key? 'ARUBA_NO_COVERAGE'

SimpleCov.configure do
  # ignore this file
  add_filter '.simplecov'
  add_filter 'spec'
  add_filter 'features'

  # Rake tasks aren't tested with rspec
  add_filter 'Rakefile'
  add_filter 'lib/tasks'

  #
  # Changed Files in Git Group
  # @see http://fredwu.me/post/35625566267/simplecov-test-coverage-for-changed-files-only
  untracked         = `git ls-files --exclude-standard --others`
  unstaged          = `git diff --name-only`
  staged            = `git diff --name-only --cached`
  all               = untracked + unstaged + staged
  changed_filenames = all.split("\n")

  add_group 'Changed' do |source_file|
    changed_filenames.select do |changed_filename|
      source_file.filename.end_with?(changed_filename)
    end
  end

  add_group 'Libraries', 'lib'

  # Specs are reported on to ensure that all examples are being run and all
  # lets, befores, afters, etc are being used.
  add_group 'Specs', 'spec'
end
