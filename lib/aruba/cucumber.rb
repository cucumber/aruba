require 'aruba/api'
require 'aruba/hooks'

World(Aruba::Api)

Given /^I'm using a clean gemset "([^"]*)"$/ do |gemset|
  use_clean_gemset(gemset)
end

Given /^a directory named "([^"]*)"$/ do |dir_name|
  create_dir(dir_name)
end

Given /^a file named "([^"]*)" with:$/ do |file_name, file_content|
  write_file(file_name, file_content)
end

Given /^an empty file named "([^"]*)"$/ do |file_name|
  write_file(file_name, "")
end

When /^I write to "([^"]*)" with:$/ do |file_name, file_content|
  write_file(file_name, file_content)
end

When /^I overwrite "([^"]*)" with:$/ do |file_name, file_content|
  overwrite_file(file_name, file_content)
end

When /^I append to "([^"]*)" with:$/ do |file_name, file_content|
  append_to_file(file_name, file_content)
end

When /^I remove the file "([^"]*)"$/ do |file_name|
  remove_file(file_name)
end

When /^I cd to "([^"]*)"$/ do |dir|
  cd(dir)
end

When /^I run "(.*)"$/ do |cmd|
  warn(%{\e[35m    The /^I run "(.*)"$/ step definition is deprecated. Please use the `backticks` version\e[0m})
  run_simple(unescape(cmd), false)
end

When /^I run `([^`]*)`$/ do |cmd|
  run_simple(unescape(cmd), current_dir, false)
end

When /^I run `([^`]*)` in "([^"]*)"$/ do |cmd, dir|
  run_simple(unescape(cmd), dir, false)
end

When /^I successfully run "(.*)"$/ do |cmd|
  warn(%{\e[35m    The  /^I successfully run "(.*)"$/ step definition is deprecated. Please use the `backticks` version\e[0m})
  run_simple(unescape(cmd))
end

When /^I successfully run `([^`]*)`$/ do |cmd|
  run_simple(unescape(cmd))
end

When /^I successfully run `([^`]*)` in "([^"]*)"$/ do |cmd, dir|
  run_simple(unescape(cmd), dir)
end

When /^I run "([^"]*)" interactively$/ do |cmd|
  warn(%{\e[35m    The /^I run "([^"]*)" interactively$/ step definition is deprecated. Please use the I interactively run `backticks` version\e[0m})
  run_interactive(unescape(cmd))
end

When /^I run `([^`]*)` interactively$/ do |cmd|
  warn(%{\e[35m    The /^I run `([^"]*)` interactively$/ step definition is deprecated. Please use the I interactively run `backticks` version\e[0m})
  run_interactive(unescape(cmd))
end

When /^I interactively run `([^`]*)`$/ do |cmd|
  run_interactive(unescape(cmd))
end

When /^I interactively run `([^`]*)` in "([^"]*)"$/ do |cmd, dir|
  run_interactive(unescape(cmd), dir)
end

When /^I type "([^"]*)"$/ do |input|
  type(input)
end

Then /^the output should contain "([^"]*)"$/ do |partial_output|
  assert_partial_output(partial_output)
end

Then /^the output from "([^"]*)" should contain "([^"]*)"$/ do |cmd, partial_output|
  output_from(cmd).should include(partial_output)
end

Then /^the output from "([^"]*)" should not contain "([^"]*)"$/ do |cmd, partial_output|
  output_from(cmd).should_not include(partial_output)
end

Then /^the output should not contain "([^"]*)"$/ do |partial_output|
  all_output.should_not include(partial_output)
end

Then /^the output should contain:$/ do |partial_output|
  all_output.should include(partial_output)
end

Then /^the output should not contain:$/ do |partial_output|
  all_output.should_not include(partial_output)
end

Then /^the output should contain exactly "([^"]*)"$/ do |exact_output|
  all_output.should == exact_output
end

Then /^the output should contain exactly:$/ do |exact_output|
  all_output.should == exact_output
end

# "the output should match" allows regex in the partial_output, if
# you don't need regex, use "the output should contain" instead since
# that way, you don't have to escape regex characters that
# appear naturally in the output
Then /^the output should match \/([^\/]*)\/$/ do |partial_output|
  all_output.should =~ /#{partial_output}/
end
 
Then /^the output should match:$/ do |partial_output|
  all_output.should =~ /#{partial_output}/m
end

Then /^the exit status should be (\d+)$/ do |exit_status|
  @last_exit_status.should == exit_status.to_i
end

Then /^the exit status should not be (\d+)$/ do |exit_status|
  @last_exit_status.should_not == exit_status.to_i
end

Then /^it should (pass|fail) with:$/ do |pass_fail, partial_output|
  self.__send__("assert_#{pass_fail}ing_with", partial_output)
end

Then /^it should (pass|fail) with exactly:$/ do |pass_fail, exact_output|
  assert_exit_status_and_output(pass_fail == "pass", exact_output, true)
end

Then /^it should (pass|fail) with regexp?:$/ do |pass_fail, partial_output|
  Then "the output should match:", partial_output
  if pass_fail == 'pass'
    @last_exit_status.should == 0
  else
    @last_exit_status.should_not == 0
  end
end

Then /^the stderr should contain "([^"]*)"$/ do |partial_output|
  all_stderr.should include(partial_output)
end

Then /^the stderr should contain:$/ do |partial_output|
  all_stderr.should include(partial_output)
end

Then /^the stderr should contain exactly:$/ do |exact_output|
  all_stderr.should == exact_output
end

Then /^the stdout should contain "([^"]*)"$/ do |partial_output|
  all_stdout.should include(partial_output)
end

Then /^the stdout should contain:$/ do |partial_output|
  all_stdout.should include(partial_output)
end

Then /^the stdout should contain exactly:$/ do |exact_output|
  all_stdout.should == exact_output
end

Then /^the stderr should not contain "([^"]*)"$/ do |partial_output|
  all_stderr.should_not include(partial_output)
end

Then /^the stderr should not contain:$/ do |partial_output|
  all_stderr.should_not include(partial_output)
end

Then /^the stdout should not contain "([^"]*)"$/ do |partial_output|
  all_stdout.should_not include(partial_output)
end

Then /^the stdout should not contain:$/ do |partial_output|
  all_stdout.should_not include(partial_output)
end

Then /^the stdout from "([^"]*)" should contain "([^"]*)"$/ do |cmd, partial_output|
  stdout_from(cmd).should include(partial_output)
end

Then /^the stdout from "([^"]*)" should not contain "([^"]*)"$/ do |cmd, partial_output|
  stdout_from(cmd).should_not include(partial_output)
end

Then /^the stderr from "([^"]*)" should contain "([^"]*)"$/ do |cmd, partial_output|
  stderr_from(cmd).should include(partial_output)
end

Then /^the stderr from "([^"]*)" should not contain "([^"]*)"$/ do |cmd, partial_output|
  stderr_from(cmd).should_not include(partial_output)
end

Then /^the file "([^"]*)" should not exist$/ do |file_name|
  check_file_presence([file_name], false)
end

Then /^the following files should exist:$/ do |files|
  check_file_presence(files.raw.map{|file_row| file_row[0]}, true)
end

Then /^the following files should not exist:$/ do |files|
  check_file_presence(files.raw.map{|file_row| file_row[0]}, false)
end

Then /^a file named "([^"]*)" should exist$/ do |file|
  check_file_presence([file], true)
end

Then /^a file named "([^"]*)" should not exist$/ do |file|
  check_file_presence([file], false)
end

Then /^the following directories should exist:$/ do |directories|
  check_directory_presence(directories.raw.map{|directory_row| directory_row[0]}, true)
end

Then /^the following directories should not exist:$/ do |directories|
  check_directory_presence(directories.raw.map{|directory_row| directory_row[0]}, false)
end

Then /^a directory named "([^"]*)" should exist$/ do |directory|
  check_directory_presence([directory], true)
end

Then /^a directory named "([^"]*)" should not exist$/ do |directory|
  check_directory_presence([directory], false)
end

Then /^the file "([^"]*)" should contain "([^"]*)"$/ do |file, partial_content|
  check_file_content(file, partial_content, true)
end

Then /^the file "([^"]*)" should not contain "([^"]*)"$/ do |file, partial_content|
  check_file_content(file, partial_content, false)
end

Then /^the file "([^"]*)" should contain exactly:$/ do |file, exact_content|
  check_exact_file_content(file, exact_content)
end

Then /^the file "([^"]*)" should match \/([^\/]*)\/$/ do |file, partial_content|
  check_file_content(file, /#{partial_content}/, true)
end

Then /^the file "([^"]*)" should not match \/([^\/]*)\/$/ do |file, partial_content|
  check_file_content(file, /#{partial_content}/, false)
end
