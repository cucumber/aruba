When /^I do aruba (.*)$/ do |aruba_step|
  @aruba_exception = StandardError.new

  begin
    step(aruba_step)
  rescue => e
    @aruba_exception = e
  end
end

# Useful for debugging timing problems
When /^sleep (\d+)$/ do |time|
  sleep time.to_i
end

When /^I set env variable "(\w+)" to "([^"]*)"$/ do |var, value|
  ENV[var] = value
end

Then /^aruba should fail with "([^"]*)"$/ do |error_message|
  expect(@aruba_exception.message).to include(Aruba::Platform.unescape(error_message))
end

Then /^the following step should fail with Spec::Expectations::ExpectationNotMetError:$/ do |multiline_step|
  expect{steps multiline_step.to_s}.to raise_error(RSpec::Expectations::ExpectationNotMetError)
end

Then /^the output should be (\d+) bytes long$/ do |length|
  expect(all_output.length).to eq length.to_i
end

Then /^the feature(?:s)? should( not)?(?: all)? pass$/ do |negated|
  if negated
    step 'the output should contain " failed)"'
    step 'the exit status should be 1'
  else
    step 'the output should not contain " failed)"'
    step 'the exit status should be 0'
  end
end

Then /^the feature(?:s)? should( not)?(?: all)? pass with:$/ do |negated, string|
  if negated
    step 'the output should contain " failed)"'
    step 'the exit status should be 1'
  else
    step 'the output should not contain " failed)"'
    step 'the exit status should be 0'
  end

  step 'the output should contain:', string if string
end

Then /^the spec(?:s)? should( not)?(?: all)? pass(?: with (\d+) failures?)?$/ do |negated, count_failures|
  if negated
    if count_failures.nil?
      step 'the output should not contain "0 failures"'
    else
      step %(the output should contain "#{count_failures} failures")
    end

    step 'the exit status should be 1'
  else
    step 'the output should contain "0 failures"'
    step 'the exit status should be 0'
  end
end

Then /^the spec(?:s)? should( not)?(?: all)? pass with:$/ do |negated, string|
  if negated
    step 'the output should contain " failed)"'
    step 'the exit status should be 1'
  else
    step 'the output should not contain " failed)"'
    step 'the exit status should be 0'
  end

  step 'the output should contain:', string if string
end

Given(/^the default feature-test$/) do
  step(
    'a file named "features/default.feature" with:',
    <<-EOS.strip_heredoc
    Feature: Default Feature

      This is the default feature

      Scenario: Run command
        Given I successfully run `cli`
    EOS
  )
end

Given(/^(?:an|the) executable(?: named)? "([^"]*)" with:$/) do |file_name, file_content|
  step %(a file named "#{file_name}" with mode "0755" and with:), file_content
end
