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
  expect(@aruba_exception.message).to include sanitize_text(error_message)
end

Then /^the following step should fail with Spec::Expectations::ExpectationNotMetError:$/ do |multiline_step|
  expect{steps multiline_step.to_s}.to raise_error(RSpec::Expectations::ExpectationNotMetError)
end

Given(/^the default executable$/) do
  step 'an executable named "bin/cli" with:', <<-EOS
#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'cli/app'

exit 0
  EOS
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

Then(/^aruba should be installed on the local system$/) do
  run('gem list aruba')
  expect(last_command_started).to have_output(/aruba/)
end
