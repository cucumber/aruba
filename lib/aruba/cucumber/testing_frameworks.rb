# frozen_string_literal: true

# Cucumber
Then(/^the feature(?:s)? should not(?: all)? pass$/) do
  step 'the output should contain " failed)"'
  step 'the exit status should be 1'
end

# Cucumber
Then(/^the feature(?:s)? should(?: all)? pass$/) do
  step 'the output should not contain " failed)"'
  step 'the output should not contain " undefined)"'
  step 'the exit status should be 0'
end

# Cucumber
Then(/^the feature(?:s)? should not(?: all)? pass with( regex)?:$/) do |regex, string|
  step 'the output should contain " failed)"'
  step 'the exit status should be 1'

  if regex
    step "the output should match %r<#{string}>"
  else
    step 'the output should contain:', string
  end
end

# Cucumber
Then(/^the feature(?:s)? should(?: all)? pass with( regex)?:$/) do |regex, string|
  step 'the output should not contain " failed)"'
  step 'the output should not contain " undefined)"'
  step 'the exit status should be 0'

  if regex
    step "the output should match %r<#{string}>"
  else
    step 'the output should contain:', string
  end
end

# RSpec
Then(/^the spec(?:s)? should not(?: all)? pass(?: with (\d+) failures?)?$/) \
  do |count_failures|
  if count_failures.nil?
    step 'the output should not contain "0 failures"'
  else
    step %(the output should contain "#{count_failures} failures")
  end

  step 'the exit status should be 1'
end

# RSpec
Then(/^the spec(?:s)? should all pass$/) do
  expect(last_command_stopped)
    .to have_output an_output_string_matching('^[1-9][0-9]* examples?, 0 failures$')

  if last_command_stopped.exit_status != 0
    expect(last_command_stopped)
      .to have_output an_output_string_matching(', [1-9][0-9]* failure')
    expect(last_command_stopped).to have_exit_status 0
  end
end

# RSpec
Then(/^the spec(?:s)? should not(?: all)? pass with( regex)?:$/) do |regex, string|
  step 'the output should not contain "0 failures"'
  step 'the exit status should be 1'

  if regex
    step "the output should match %r<#{string}>"
  else
    step 'the output should contain:', string
  end
end

# RSpec
Then(/^the spec(?:s)? should(?: all)? pass with( regex)?:$/) do |regex, string|
  step 'the output should contain "0 failures"'
  step 'the exit status should be 0'

  if regex
    step "the output should match %r<#{string}>"
  else
    step 'the output should contain:', string
  end
end

# Minitest
Then(/^the tests(?:s)? should not(?: all)? pass(?: with (\d+) failures?)?$/) \
  do |count_failures|
  if count_failures.nil?
    step 'the output should not contain "0 errors"'
  else
    step %(the output should contain "#{count_failures} errors")
  end

  step 'the exit status should be 1'
end

# Minitest
Then(/^the tests(?:s)? should all pass$/) do
  step 'the output should contain "0 errors"'
  step 'the exit status should be 0'
end

# Minitest
Then(/^the test(?:s)? should not(?: all)? pass with( regex)?:$/) do |regex, string|
  step 'the output should contain "0 errors"'
  step 'the exit status should be 1'

  if regex
    step "the output should match %r<#{string}>"
  else
    step 'the output should contain:', string
  end
end

# Minitest
Then(/^the test(?:s)? should(?: all)? pass with( regex)?:$/) do |regex, string|
  step 'the output should not contain "0 errors"'
  step 'the exit status should be 0'

  if regex
    step "the output should match %r<#{string}>"
  else
    step 'the output should contain:', string
  end
end
