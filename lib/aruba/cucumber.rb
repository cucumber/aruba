require 'aruba/api'

World(Aruba::Api)

Before do
  FileUtils.rm_rf(current_dir)
end

Given /^a directory named "([^\"]*)"$/ do |dir_name|
  create_dir(dir_name)
end

Given /^a file named "([^\"]*)" with:$/ do |file_name, file_content|
  create_file(file_name, file_content)
end

When /^I append to "([^\"]*)" with:$/ do |file_name, file_content|
  append_to_file(file_name, file_content)
end

When /^I cd to "([^\"]*)"$/ do |dir|
  cd(dir)
end

When /^I run "(.*)"$/ do |cmd|
  run(unescape(cmd))
end

Then /^I should see "([^\"]*)"$/ do |partial_output|
  combined_output.should =~ compile_and_escape(partial_output)
end

Then /^I should not see "([^\"]*)"$/ do |partial_output|
  combined_output.should_not =~ compile_and_escape(partial_output)
end

Then /^I should see:$/ do |partial_output|
  combined_output.should =~ compile_and_escape(partial_output)
end

Then /^I should not see:$/ do |partial_output|
  combined_output.should_not =~ compile_and_escape(partial_output)
end

Then /^I should see exactly "([^\"]*)"$/ do |exact_output|
  combined_output.should == unescape(exact_output)
end

Then /^I should see exactly:$/ do |exact_output|
  combined_output.should == exact_output
end

Then /^the exit status should be (\d+)$/ do |exit_status|
  @last_exit_status.should == exit_status.to_i
end

Then /^the exit status should not be (\d+)$/ do |exit_status|
  @last_exit_status.should_not == exit_status.to_i
end

Then /^it should (pass|fail) with:$/ do |pass_fail, partial_output|
  if pass_fail == 'pass'
    @last_exit_status.should == 0
  else
    @last_exit_status.should_not == 0
  end
  Then "I should see:", partial_output
end

Then /^the stderr should contain "([^\"]*)"$/ do |partial_output|
  @last_stderr.should =~ compile_and_escape(partial_output)
end

Then /^the stdout should contain "([^\"]*)"$/ do |partial_output|
  @last_stdout.should =~ compile_and_escape(partial_output)
end

Then /^the stderr should not contain "([^\"]*)"$/ do |partial_output|
  @last_stderr.should_not =~ compile_and_escape(partial_output)
end

Then /^the stdout should not contain "([^\"]*)"$/ do |partial_output|
  @last_stdout.should_not =~ compile_and_escape(partial_output)
end
