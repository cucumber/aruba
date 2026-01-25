# frozen_string_literal: true

#
# Cucumber
#
# This defines the following steps:
#
# 1. Simple pass/not pass/fail
# 2. Pass/not pass/fail with a multiline string or regex
#
# For item 2, the 'not pass' variant is deprecated because the wording makes it
# unclear how the negation should be applied.
#
Then(/^the feature(?:s)? should fail$/) do
  expect(all_output).to include_output_string ' failed)'
  expect(last_command_stopped).to have_exit_status 1
end

Then(/^the feature(?:s)? should not(?: all)? pass$/) do
  expect(all_output).to include_output_string ' failed)'
  expect(last_command_stopped).to have_exit_status 1
end

Then(/^the feature(?:s)? should(?: all)? pass$/) do
  expect(all_output).not_to include_output_string ' failed)'
  expect(all_output).not_to include_output_string ' undefined)'
  expect(last_command_stopped).to have_exit_status 0
end

Then(/^the feature(?:s)? should fail with( regex)?:$/) do |regex, string|
  expect(all_output).to include_output_string ' failed)'
  expect(last_command_stopped).to have_exit_status 1

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end

Then(/^the feature(?:s)? should not(?: all)? pass with( regex)?:$/) do |regex, string|
  Aruba.platform.deprecated \
    'This cucumber step has confusing wording and is deprecated.' \
    "Use 'the feature(s) should fail with#{regex}:' instead."
  expect(all_output).to include_output_string ' failed)'
  expect(last_command_stopped).to have_exit_status 1

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end

Then(/^the feature(?:s)? should(?: all)? pass with( regex)?:$/) do |regex, string|
  expect(all_output).not_to include_output_string ' failed)'
  expect(all_output).not_to include_output_string ' undefined)'
  expect(last_command_stopped).to have_exit_status 0

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end

#
# RSpec
#
# This defines the following steps:
#
# 1. Simple pass/not pass/fail
# 2. Not pass/fail with a failure count
# 3. Pass/not pass/fail with a multiline string or regex
#
# For items 2 and 3, the 'not pass' variant is deprecated because the wording
# makes it unclear how the negation should be applied.
#
Then(/^the spec(?:s)? should fail$/) do
  expect(all_output).not_to include_output_string '0 failures'
  expect(last_command_stopped).to have_exit_status 1
end

Then(/^the spec(?:s)? should not(?: all)? pass$/) do
  expect(all_output).not_to include_output_string '0 failures'
  expect(last_command_stopped).to have_exit_status 1
end

Then(/^the spec(?:s)? should(?: all)? pass$/) do
  expect(all_output).to include_output_string '0 failures'
  expect(last_command_stopped).to have_exit_status 0
end

Then(/^the spec(?:s)? should fail with (\d+) failures?$/) do |count|
  expect(all_output).to include_output_string "#{count} failures"

  expect(last_command_stopped).to have_exit_status 1
end

Then(/^the spec(?:s)? should not(?: all)? pass with (\d+) failures?$/) do |count|
  Aruba.platform.deprecated \
    'This rspec step has confusing wording and is deprecated.' \
    "Use 'the spec(s) should fail with #{count} failures' instead."
  expect(all_output).to include_output_string "#{count} failures"

  expect(last_command_stopped).to have_exit_status 1
end

Then(/^the spec(?:s)? should fail with( regex)?:$/) do |regex, string|
  expect(all_output).not_to include_output_string '0 failures'
  expect(last_command_stopped).to have_exit_status 1

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end

Then(/^the spec(?:s)? should not(?: all)? pass with( regex)?:$/) do |regex, string|
  Aruba.platform.deprecated \
    'This rspec step has confusing wording and is deprecated.' \
    "Use 'the spec(s) should fail with#{regex}:' instead."
  expect(all_output).not_to include_output_string '0 failures'
  expect(last_command_stopped).to have_exit_status 1

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end

Then(/^the spec(?:s)? should(?: all)? pass with( regex)?:$/) do |regex, string|
  expect(all_output).to include_output_string '0 failures'
  expect(last_command_stopped).to have_exit_status 0

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end

#
# Minitest
#
# This defines the following steps:
#
# 1. Simple pass/not pass/fail
# 2. Not pass/fail with a failure count
# 3. Pass/not pass/fail with a multiline string or regex
#
# For items 2 and 3, the 'not pass' variant is deprecated because the wording
# makes it unclear how the negation should be applied.
#
Then(/^the test(?:s)? should fail$/) do
  expect(all_output).not_to include_output_string '0 errors'
  expect(last_command_stopped).to have_exit_status 1
end

Then(/^the tests(?:s)? should not(?: all)? pass$/) do
  expect(all_output).not_to include_output_string '0 errors'
  expect(last_command_stopped).to have_exit_status 1
end

Then(/^the tests(?:s)? should(?: all)? pass$/) do
  expect(all_output).to include_output_string '0 errors'
  expect(last_command_stopped).to have_exit_status 0
end

Then(/^the test(?:s)? should fail with (\d+) errors?$/) do |count|
  expect(all_output).to include_output_string "#{count} errors"
  expect(last_command_stopped).to have_exit_status 1
end

Then(/^the tests(?:s)? should not(?: all)? pass with (\d+) failures?$/) do |count|
  Aruba.platform.deprecated \
    'This minitest step has confusing wording and is deprecated.' \
    "Use 'the test(s) should fail #{count} errors' instead."
  expect(all_output).to include_output_string "#{count} errors"
  expect(last_command_stopped).to have_exit_status 1
end

Then(/^the test(?:s)? should fail with( regex)?:$/) do |regex, string|
  expect(all_output).not_to include_output_string '0 errors'
  expect(last_command_stopped).to have_exit_status 1

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end

Then(/^the test(?:s)? should not(?: all)? pass with( regex)?:$/) do |regex, string|
  Aruba.platform.deprecated \
    'This minitest step has confusing wording and is deprecated.' \
    "Use 'the test(s) should fail with#{regex}:' instead."
  expect(all_output).not_to include_output_string '0 errors'
  expect(last_command_stopped).to have_exit_status 1

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end

Then(/^the test(?:s)? should(?: all)? pass with( regex)?:$/) do |regex, string|
  expect(all_output).not_to include_output_string '0 errors'
  expect(last_command_stopped).to have_exit_status 0

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end
