Given /^I have a local file named "([^\"]*)" with:$/ do |filename, content|
  File.open(filename, 'w') {|io| io.write(content)}
end

When /^I do aruba (.*)$/ do |aruba_step|
  begin
    When(aruba_step)
  rescue => e
    @aruba_exception = e
  end
end

Then /^I should see the JRuby version$/ do
  pending "This must be manually run in JRuby" unless defined?(JRUBY_VERSION)
  Then %{I should see "#{JRUBY_VERSION}"}
end

Then /^I should see the current Ruby version$/ do
  Then %{I should see "#{RUBY_VERSION}"}
end

Then /^aruba should fail with "([^\"]*)"$/ do |error_message|
  @aruba_exception.message.should =~ compile_and_escape(error_message)
end
