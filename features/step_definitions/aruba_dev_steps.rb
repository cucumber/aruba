When /^I do aruba (.*)$/ do |aruba_step|
  begin
    When(aruba_step)
  rescue => e
    @aruba_exception = e
  end
end

Then /^aruba should fail with "([^"]*)"$/ do |error_message|
  @aruba_exception.message.should include(unescape(error_message))
end

Then /^the following step should fail with Spec::Expectations::ExpectationNotMetError:$/ do |multiline_step|
  proc {steps multiline_step}.should raise_error(RSpec::Expectations::ExpectationNotMetError)
end
