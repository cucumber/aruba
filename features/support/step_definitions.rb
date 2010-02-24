Given /^I have a local file named "([^\"]*)" with:$/ do |filename, content|
  File.open(filename, 'w') {|io| io.write(content)}
end

Then /^I should see the JRuby version$/ do
  Then %{I should see "#{JRUBY_VERSION}"}
end
