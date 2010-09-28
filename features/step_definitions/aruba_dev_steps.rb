When /^I do aruba (.*)$/ do |aruba_step|
  begin
    When(aruba_step)
  rescue => e
    @aruba_exception = e
  end
end

Then /^aruba should fail with "([^"]*)"$/ do |error_message|
  @aruba_exception.message.should =~ regexp(error_message)
end
