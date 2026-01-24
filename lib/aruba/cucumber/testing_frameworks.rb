# frozen_string_literal: true

# Cucumber
Then(/^the feature(?:s)? should not(?: all)? pass$/) do
  expect(all_output).to include_output_string ' failed)'
  expect(last_command_stopped).to have_exit_status 1
end

# Cucumber
Then(/^the feature(?:s)? should(?: all)? pass$/) do
  expect(all_output).not_to include_output_string ' failed)'
  expect(all_output).not_to include_output_string ' undefined)'
  expect(last_command_stopped).to have_exit_status 0
end

# Cucumber
Then(/^the feature(?:s)? should not(?: all)? pass with( regex)?:$/) do |regex, string|
  expect(all_output).to include_output_string ' failed)'
  expect(last_command_stopped).to have_exit_status 1

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end

# Cucumber
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

# RSpec
Then(/^the spec(?:s)? should not(?: all)? pass(?: with (\d+) failures?)?$/) \
  do |count_failures|
  if count_failures.nil?
    expect(all_output).not_to include_output_string '0 failures'
  else
    expect(all_output).to include_output_string "#{count_failures} failures"
  end

  expect(last_command_stopped).to have_exit_status 1
end

# RSpec
Then(/^the spec(?:s)? should all pass$/) do
  expect(all_output).to include_output_string '0 failures'
  expect(last_command_stopped).to have_exit_status 0
end

# RSpec
Then(/^the spec(?:s)? should not(?: all)? pass with( regex)?:$/) do |regex, string|
  expect(all_output).not_to include_output_string '0 failures'
  expect(last_command_stopped).to have_exit_status 1

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end

# RSpec
Then(/^the spec(?:s)? should(?: all)? pass with( regex)?:$/) do |regex, string|
  expect(all_output).to include_output_string '0 failures'
  expect(last_command_stopped).to have_exit_status 0

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end

# Minitest
Then(/^the tests(?:s)? should not(?: all)? pass(?: with (\d+) failures?)?$/) \
  do |count_failures|
  if count_failures.nil?
    expect(all_output).not_to include_output_string '0 errors'
  else
    expect(all_output).to include_output_string "#{count_failures} errors"
  end

  expect(last_command_stopped).to have_exit_status 1
end

# Minitest
Then(/^the tests(?:s)? should all pass$/) do
  expect(all_output).to include_output_string '0 errors'
  expect(last_command_stopped).to have_exit_status 0
end

# Minitest
Then(/^the test(?:s)? should not(?: all)? pass with( regex)?:$/) do |regex, string|
  expect(all_output).to include_output_string '0 errors'
  expect(last_command_stopped).to have_exit_status 1

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end

# Minitest
Then(/^the test(?:s)? should(?: all)? pass with( regex)?:$/) do |regex, string|
  expect(all_output).not_to include_output_string '0 errors'
  expect(last_command_stopped).to have_exit_status 0

  if regex
    expect(all_output).to match_output_string(string)
  else
    expect(all_output).to include_output_string(string)
  end
end
