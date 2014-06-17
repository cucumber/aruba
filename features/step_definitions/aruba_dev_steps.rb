When /^I do aruba (.*)$/ do |aruba_step|
  begin
    step(aruba_step)
  rescue Exception => e
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
  expect(@aruba_exception.message).to include(unescape(error_message))
end

Then /^the following step should fail with Spec::Expectations::ExpectationNotMetError:$/ do |multiline_step|
  expect{steps multiline_step}.to raise_error(RSpec::Expectations::ExpectationNotMetError)
end

Then /^the output should be (\d+) bytes long$/ do |length|
  expect(all_output.length).to eq length.to_i
end
