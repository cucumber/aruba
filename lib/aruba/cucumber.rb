require 'aruba/api'
require 'aruba/cucumber/hooks'
require 'aruba/reporting'

World(Aruba::Api)

Given /the default aruba timeout is (\d+) seconds/ do |seconds|
  @aruba_timeout_seconds = seconds.to_i
end

Given /The default aruba timeout is (\d+) seconds/ do |seconds|
  warn(%{\e[35m    The  /^The default aruba timeout is (\d+) seconds/ step definition is deprecated. Please use the one with `the` and not `The` at the beginning.\e[0m})
  @aruba_timeout_seconds = seconds.to_i
end

Given /^I'm using a clean gemset "([^"]*)"$/ do |gemset|
  use_clean_gemset(gemset)
end

Given /^a directory named "([^"]*)"$/ do |dir_name|
  create_dir(dir_name)
end

Given /^a directory named "([^"]*)" with mode "([^"]*)"$/ do |dir_name, dir_mode|
  create_dir(dir_name)
  chmod(dir_mode, dir_name)
end

Given /^a file named "([^"]*)" with:$/ do |file_name, file_content|
  write_file(file_name, file_content)
end

Given /^a file named "([^"]*)" with mode "([^"]*)" and with:$/ do |file_name, file_mode, file_content|
  write_file(file_name, file_content)
  chmod(file_mode, file_name)
end

Given /^a (\d+) byte file named "([^"]*)"$/ do |file_size, file_name|
  write_fixed_size_file(file_name, file_size.to_i)
end

Given /^an empty file named "([^"]*)"$/ do |file_name|
  write_file(file_name, "")
end

Given /^an empty file named "([^"]*)" with mode "([^"]*)"$/ do |file_name, file_mode|
  write_file(file_name, "")
  chmod(file_mode, file_name)
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

When /^I append to "([^"]*)" with "([^"]*)"$/ do |file_name, file_content|
  append_to_file(file_name, file_content)
end

When /^I remove the file "([^"]*)"$/ do |file_name|
  remove_file(file_name)
end

When /^I cd to "([^"]*)"$/ do |dir|
  cd(dir)
end

Given /^I set the environment variables to:/ do |table|
  table.hashes.each do |row|
    variable = row['variable'].to_s.upcase
    value = row['value'].to_s

    set_env(variable, value)
  end
end

When /^I run "(.*)"$/ do |cmd|
  warn(%{\e[35m    The /^I run "(.*)"$/ step definition is deprecated. Please use the `backticks` version\e[0m})
  run_simple(unescape(cmd), false)
end

When /^I run `([^`]*)`$/ do |cmd|
  run_simple(unescape(cmd), false)
end

When /^I successfully run "(.*)"$/ do |cmd|
  warn(%{\e[35m    The  /^I successfully run "(.*)"$/ step definition is deprecated. Please use the `backticks` version\e[0m})
  run_simple(unescape(cmd))
end

## I successfully run `echo -n "Hello"`
## I successfully run `sleep 29` for up to 30 seconds
When /^I successfully run `(.*?)`(?: for up to (\d+) seconds)?$/ do |cmd, secs|
  run_simple(unescape(cmd), true, secs && secs.to_i)
end

When /^I run "([^"]*)" interactively$/ do |cmd|
  warn(%{\e[35m    The /^I run "([^"]*)" interactively$/ step definition is deprecated. Please use the `backticks` version\e[0m})
  run_interactive(unescape(cmd))
end

When /^I run `([^`]*)` interactively$/ do |cmd|
  run_interactive(unescape(cmd))
end

When /^I type "([^"]*)"$/ do |input|
  type(input)
end

When /^I close the stdin stream$/ do
  close_input
end

When /^I pipe in the file "([^"]*)"$/ do |file|
  pipe_in_file(file)

  close_input
end

When /^I wait for (?:output|stdout) to contain "([^"]*)"$/ do |expected|
  Timeout::timeout(exit_timeout) do
    loop do
      break if assert_partial_output_interactive(expected)
      sleep 0.1
    end
  end
end

Then /^the output should contain "([^"]*)"$/ do |expected|
  assert_partial_output(expected, all_output)
end

Then /^the output from "([^"]*)" should contain "([^"]*)"$/ do |cmd, expected|
  assert_partial_output(expected, output_from(cmd))
end

Then /^the output from "([^"]*)" should not contain "([^"]*)"$/ do |cmd, unexpected|
  assert_no_partial_output(unexpected, output_from(cmd))
end

Then /^the output should not contain "([^"]*)"$/ do |unexpected|
  assert_no_partial_output(unexpected, all_output)
end

Then /^the output should contain:$/ do |expected|
  assert_partial_output(expected, all_output)
end

Then /^the output should not contain:$/ do |unexpected|
  assert_no_partial_output(unexpected, all_output)
end

## the output should contain exactly "output"
## the output from `echo -n "Hello"` should contain exactly "Hello"
Then /^the output(?: from "(.*?)")? should contain exactly "(.*?)"$/ do |cmd, expected|
  assert_exact_output(expected, cmd ? output_from(cmd) : all_output)
end

## the output should contain exactly:
## the output from `echo -n "Hello"` should contain exactly:
Then /^the output(?: from "(.*?)")? should contain exactly:$/ do |cmd, expected|
  assert_exact_output(expected, cmd ? output_from(cmd) : all_output)
end

# "the output should match" allows regex in the partial_output, if
# you don't need regex, use "the output should contain" instead since
# that way, you don't have to escape regex characters that
# appear naturally in the output
Then /^the output should match \/([^\/]*)\/$/ do |expected|
  assert_matching_output(expected, all_output)
end

Then /^the output should match:$/ do |expected|
  assert_matching_output(expected, all_output)
end

# The previous two steps antagonists
Then /^the output should not match \/([^\/]*)\/$/ do |expected|
  assert_not_matching_output(expected, all_output)
end

Then /^the output should not match:$/ do |expected|
  assert_not_matching_output(expected, all_output)
end

Then /^the exit status should be (\d+)$/ do |exit_status|
  assert_exit_status(exit_status.to_i)
end

Then /^the exit status should not be (\d+)$/ do |exit_status|
  assert_not_exit_status(exit_status.to_i)
end

Then /^it should (pass|fail) with:$/ do |pass_fail, partial_output|
  self.__send__("assert_#{pass_fail}ing_with", partial_output)
end

Then /^it should (pass|fail) with exactly:$/ do |pass_fail, exact_output|
  assert_exit_status_and_output(pass_fail == "pass", exact_output, true)
end

Then /^it should (pass|fail) with regexp?:$/ do |pass_fail, expected|
  assert_matching_output(expected, all_output)
  assert_success(pass_fail == 'pass')
end

## the stderr should contain "hello"
## the stderr from "echo -n 'Hello'" should contain "hello"
## the stderr should contain exactly:
## the stderr from "echo -n 'Hello'" should contain exactly:
Then /^the stderr(?: from "(.*?)")? should contain( exactly)? "(.*?)"$/ do |cmd, exact, expected|
  if exact
    assert_exact_output(expected, cmd ? stderr_from(cmd) : all_stderr)
  else
    assert_partial_output(expected, cmd ? stderr_from(cmd) : all_stderr)
  end
end

## the stderr should contain:
## the stderr from "echo -n 'Hello'" should contain:
## the stderr should contain exactly:
## the stderr from "echo -n 'Hello'" should contain exactly:
Then /^the stderr(?: from "(.*?)")? should contain( exactly)?:$/ do |cmd, exact, expected|
  if exact
    assert_exact_output(expected, cmd ? stderr_from(cmd) : all_stderr)
  else
    assert_partial_output(expected, cmd ? stderr_from(cmd) : all_stderr)
  end
end

## the stdout should contain "hello"
## the stdout from "echo -n 'Hello'" should contain "hello"
## the stdout should contain exactly:
## the stdout from "echo -n 'Hello'" should contain exactly:
Then /^the stdout(?: from "(.*?)")? should contain( exactly)? "(.*?)"$/ do |cmd, exact, expected|
  if exact
    assert_exact_output(expected, cmd ? stdout_from(cmd) : all_stdout)
  else
    assert_partial_output(expected, cmd ? stdout_from(cmd) : all_stdout)
  end
end

## the stdout should contain:
## the stdout from "echo -n 'Hello'" should contain:
## the stdout should contain exactly:
## the stdout from "echo -n 'Hello'" should contain exactly:
Then /^the stdout(?: from "(.*?)")? should contain( exactly)?:$/ do |cmd, exact, expected|
  if exact
    assert_exact_output(expected, cmd ? stdout_from(cmd) : all_stdout)
  else
    assert_partial_output(expected, cmd ? stdout_from(cmd) : all_stdout)
  end
end

Then /^the stderr should not contain "([^"]*)"$/ do |unexpected|
  assert_no_partial_output(unexpected, all_stderr)
end

Then /^the stderr should not contain:$/ do |unexpected|
  assert_no_partial_output(unexpected, all_stderr)
end

Then /^the (stderr|stdout) should not contain anything$/ do |stream_name|
  stream = self.send("all_#{stream_name}")
  expect(stream).to be_empty
end

Then /^the stdout should not contain "([^"]*)"$/ do |unexpected|
  assert_no_partial_output(unexpected, all_stdout)
end

Then /^the stdout should not contain:$/ do |unexpected|
  assert_no_partial_output(unexpected, all_stdout)
end

Then /^the stdout from "([^"]*)" should not contain "([^"]*)"$/ do |cmd, unexpected|
  assert_no_partial_output(unexpected, stdout_from(cmd))
end

Then /^the stderr from "([^"]*)" should not contain "([^"]*)"$/ do |cmd, unexpected|
  assert_no_partial_output(unexpected, stderr_from(cmd))
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

Then /^a file matching %r<(.*?)> should exist$/ do |regex|
  check_file_presence([ Regexp.new( regex ) ], true )
end

Then /^a file matching %r<(.*?)> should not exist$/ do |regex|
  check_file_presence([ Regexp.new( regex ) ], false )
end

Then /^a (\d+) byte file named "([^"]*)" should exist$/ do |file_size, file_name|
  check_file_size([[file_name, file_size.to_i]])
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

Then /^the file "([^"]*)" should contain:$/ do |file, partial_content|
  check_file_content(file, partial_content, true)
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

Then /^the mode of filesystem object "([^"]*)" should match "([^"]*)"$/ do |name, mode|
  mod?(mode, name)
end

Given /^a mocked home directory$/ do
  set_env 'HOME', File.expand_path(current_dir)
end

Before '@mocked_home_directory' do
  set_env 'HOME', File.expand_path(current_dir)
end

After do
  restore_env
end
