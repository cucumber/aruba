require 'aruba/api'

World(Aruba::Api)

Before do
  FileUtils.rm_rf(current_dir)
end

Before('@puts') do
  @puts = true
end

Before('@announce-cmd') do
  @announce_cmd = true
end

Before('@announce-stdout') do
  @announce_stdout = true
end

Before('@announce-stderr') do
  @announce_stderr = true
end

Before('@announce') do
  @announce_stdout = true
  @announce_stderr = true
  @announce_cmd = true
end

Given /^I am using rvm "([^"]*)"$/ do |rvm_ruby_version|
  use_rvm(rvm_ruby_version)
end

Given /^I am using( an empty)? rvm gemset "([^"]*)"$/ do |empty_gemset, rvm_gemset|
  use_rvm_gemset(rvm_gemset, empty_gemset)
end

Given /^I am using rvm gemset "([^"]*)" with Gemfile:$/ do |rvm_gemset, gemfile|
  use_rvm_gemset(rvm_gemset, true)
  install_gems(gemfile)
end

Given /^a directory named "([^"]*)"$/ do |dir_name|
  create_dir(dir_name)
end

Given /^a file named "([^"]*)" with:$/ do |file_name, file_content|
  create_file(file_name, file_content)
end

Given /^an empty file named "([^"]*)"$/ do |file_name|
  create_file(file_name, "")
end

When /^I write to "([^"]*)" with:$/ do |file_name, file_content|
  create_file(file_name, file_content)
end

When /^I append to "([^"]*)" with:$/ do |file_name, file_content|
  append_to_file(file_name, file_content)
end

When /^I cd to "([^"]*)"$/ do |dir|
  cd(dir)
end

When /^I run "(.*)"$/ do |cmd|
  run(unescape(cmd), false)
end

When /^I successfully run "(.*)"$/ do |cmd|
  run(unescape(cmd))
end

Then /^the output should contain "([^"]*)"$/ do |partial_output|
  combined_output.should =~ compile_and_escape(partial_output)
end

Then /^the output should not contain "([^"]*)"$/ do |partial_output|
  combined_output.should_not =~ compile_and_escape(partial_output)
end

Then /^the output should contain:$/ do |partial_output|
  combined_output.should =~ compile_and_escape(partial_output)
end

Then /^the output should not contain:$/ do |partial_output|
  combined_output.should_not =~ compile_and_escape(partial_output)
end

Then /^the output should contain exactly "([^"]*)"$/ do |exact_output|
  combined_output.should == unescape(exact_output)
end

Then /^the output should contain exactly:$/ do |exact_output|
  combined_output.should == exact_output
end

# "the output should match" allows regex in the partial_output, if
# you don't need regex, use "the output should contain" instead since
# that way, you don't have to escape regex characters that
# appear naturally in the output
Then /^the output should match \/([^\/]*)\/$/ do |partial_output|
  combined_output.should =~ /#{partial_output}/
end
 
Then /^the output should match:$/ do |partial_output|
  combined_output.should =~ /#{partial_output}/m
end

Then /^the exit status should be (\d+)$/ do |exit_status|
  @last_exit_status.should == exit_status.to_i
end

Then /^the exit status should not be (\d+)$/ do |exit_status|
  @last_exit_status.should_not == exit_status.to_i
end

Then /^it should (pass|fail) with:$/ do |pass_fail, partial_output|
  Then "the output should contain:", partial_output
  if pass_fail == 'pass'
    @last_exit_status.should == 0
  else
    @last_exit_status.should_not == 0
  end
end

Then /^the stderr should contain "([^"]*)"$/ do |partial_output|
  @last_stderr.should =~ compile_and_escape(partial_output)
end

Then /^the stdout should contain "([^"]*)"$/ do |partial_output|
  @last_stdout.should =~ compile_and_escape(partial_output)
end

Then /^the stderr should not contain "([^"]*)"$/ do |partial_output|
  @last_stderr.should_not =~ compile_and_escape(partial_output)
end

Then /^the stdout should not contain "([^"]*)"$/ do |partial_output|
  @last_stdout.should_not =~ compile_and_escape(partial_output)
end

Then /^the following files should exist:$/ do |files|
  check_file_presence(files.raw.map{|file_row| file_row[0]}, true)
end

Then /^the following files should not exist:$/ do |files|
  check_file_presence(files.raw.map{|file_row| file_row[0]}, false)
end

Then /^the following directories should exist:$/ do |directories|
  check_directory_presence(directories.raw.map{|directory_row| directory_row[0]}, true)
end

Then /^the following directories should not exist:$/ do |directories|
  check_file_presence(directories.raw.map{|directory_row| directory_row[0]}, false)
end

Then /^the file "([^"]*)" should contain "([^"]*)"$/ do |file, partial_content|
  check_file_content(file, partial_content, true)
end

Then /^the file "([^"]*)" should not contain "([^"]*)"$/ do |file, partial_content|
  check_file_content(file, partial_content, false)
end
