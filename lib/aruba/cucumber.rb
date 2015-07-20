require 'aruba/version'

require 'aruba/api'
World(Aruba::Api)

require 'aruba/cucumber/hooks'
require 'aruba/reporting'

if Aruba::VERSION >= '1.0.0'
  Aruba.configure do |config|
    config.working_directory = 'tmp/cucumber'
  end
end

Given /the default aruba timeout is (\d+) seconds/ do |seconds|
  aruba.config.exit_timeout = seconds.to_i
end

Given /I use (?:a|the) fixture(?: named)? "([^"]*)"/ do |name|
  copy File.join(aruba.config.fixtures_path_prefix, name), name
  cd name
end

Given /The default aruba timeout is (\d+) seconds/ do |seconds|
  warn(%{\e[35m    The  /^The default aruba timeout is (\d+) seconds/ step definition is deprecated. Please use the one with `the` and not `The` at the beginning.\e[0m})
  aruba.config.exit_timeout = seconds.to_i
end

Given /^I'm using a clean gemset "([^"]*)"$/ do |gemset|
  use_clean_gemset(gemset)
end

Given /^(?:a|the) directory(?: named)? "([^"]*)"$/ do |dir_name|
  create_directory(dir_name)
end

Given /^(?:a|the) directory(?: named)? "([^"]*)" with mode "([^"]*)"$/ do |dir_name, dir_mode|
  create_directory(dir_name)
  chmod(dir_mode, dir_name)
end

Given /^(?:a|the) file(?: named)? "([^"]*)" with:$/ do |file_name, file_content|
  write_file(file_name, file_content)
end

Given /^(?:an|the) executable(?: named)? "([^"]*)" with:$/ do |file_name, file_content|
  step %(a file named "#{file_name}" with mode "0755" and with:), file_content
end

Given /^(?:a|the) file(?: named)? "([^"]*)" with "([^"]*)"$/ do |file_name, file_content|
  write_file(file_name, file_content)
end

Given /^(?:a|the) file(?: named)? "([^"]*)" with mode "([^"]*)" and with:$/ do |file_name, file_mode, file_content|
  write_file(file_name, file_content)
  chmod(file_mode, file_name)
end

Given /^(?:a|the) (\d+) byte file(?: named)? "([^"]*)"$/ do |file_size, file_name|
  write_fixed_size_file(file_name, file_size.to_i)
end

Given /^(?:an|the) empty file(?: named)? "([^"]*)"$/ do |file_name|
  write_file(file_name, "")
end

Given /^(?:an|the) empty file(?: named)? "([^"]*)" with mode "([^"]*)"$/ do |file_name, file_mode|
  write_file(file_name, "")
  chmod(file_mode, file_name)
end

Given /^a mocked home directory$/ do
  set_environment_variable 'HOME', expand_path('.')
end

Given /^(?:a|the) directory(?: named)? "([^"]*)" does not exist$/ do |directory_name|
  remove(directory_name, :force => true)
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

When /^I remove (?:a|the) file(?: named)? "([^"]*)"$/ do |file_name|
  remove(file_name)
end

Given /^(?:a|the) file(?: named)? "([^"]*)" does not exist$/ do |file_name|
  remove(file_name, :force => true)
end

When(/^I remove (?:a|the) directory(?: named)? "(.*?)"$/) do |directory_name|
  remove(directory_name)
end

When /^I cd to "([^"]*)"$/ do |dir|
  cd(dir)
end

Given /^I set the environment variables? to:/ do |table|
  table.hashes.each do |row|
    variable = row['variable'].to_s.upcase
    value = row['value'].to_s

    set_environment_variable(variable, value)
  end
end

Given /^I append the values? to the environment variables?:/ do |table|
  table.hashes.each do |row|
    variable = row['variable'].to_s.upcase
    value = row['value'].to_s

    append_environment_variable(variable, value)
  end
end

Given /^I prepend the values? to the environment variables?:/ do |table|
  table.hashes.each do |row|
    variable = row['variable'].to_s.upcase
    value = row['value'].to_s

    prepend_environment_variable(variable, value)
  end
end

When /^I run "(.*)"$/ do |cmd|
  warn(%{\e[35m    The /^I run "(.*)"$/ step definition is deprecated. Please use the `backticks` version\e[0m})

  cmd = unescape_text(cmd)
  cmd = extract_text(cmd) if !aruba.config.keep_ansi || aruba.config.remove_ansi_escape_sequences

  run_simple(cmd, false)
end

When /^I run `([^`]*)`$/ do |cmd|
  cmd = unescape_text(cmd)
  cmd = extract_text(cmd) if !aruba.config.keep_ansi || aruba.config.remove_ansi_escape_sequences

  run_simple(cmd, false)
end

When /^I successfully run "(.*)"$/ do |cmd|
  warn(%{\e[35m    The  /^I successfully run "(.*)"$/ step definition is deprecated. Please use the `backticks` version\e[0m})

  cmd = unescape_text(cmd)
  cmd = extract_text(cmd) if !aruba.config.keep_ansi || aruba.config.remove_ansi_escape_sequences

  run_simple(cmd)
end

## I successfully run `echo -n "Hello"`
## I successfully run `sleep 29` for up to 30 seconds
When /^I successfully run `(.*?)`(?: for up to (\d+) seconds)?$/ do |cmd, secs|
  cmd = unescape_text(cmd)
  cmd = extract_text(cmd) if !aruba.config.keep_ansi || aruba.config.remove_ansi_escape_sequences

  run_simple(cmd, true, secs && secs.to_i)
end

When /^I run "([^"]*)" interactively$/ do |cmd|
  warn(%{\e[35m    The /^I run "([^"]*)" interactively$/ step definition is deprecated. Please use the `backticks` version\e[0m})
  step %(I run `#{cmd}` interactively)
end

When /^I run `([^`]*)` interactively$/ do |cmd|
  cmd = unescape_text(cmd)
  cmd = extract_text(cmd) if !aruba.config.keep_ansi || aruba.config.remove_ansi_escape_sequences

  @interactive = run(cmd)
end

When /^I type "([^"]*)"$/ do |input|
  type(unescape_text(input))
end

When /^I close the stdin stream$/ do
  close_input
end

When /^I pipe in (?:a|the) file(?: named)? "([^"]*)"$/ do |file|
  pipe_in_file(file)

  close_input
end

When /^I stop the last command if (?:output|stdout) contains:$/ do |expected|
  begin
    Timeout.timeout(exit_timeout) do
      loop do
        if Aruba::Platform.unescape(last_command_started.output).include? Aruba::Platform.unescape(expected)
          last_command_started.terminate
          break
        end

        sleep 0.1
      end
    end
  rescue ChildProcess::TimeoutError, TimeoutError
    last_command_started.terminate
  ensure
    announcer.stdout last_command_started.stdout
    announcer.stderr last_command_started.stderr
  end
end

When /^I wait for (?:output|stdout) to contain:$/ do |expected|
  Timeout.timeout(exit_timeout) do
    loop do
      begin
        expect(last_command_started).to have_output Regexp.new(Aruba::Platform.unescape(expected, aruba.config.keep_ansi))
      rescue ExpectationError
        sleep 0.1
        retry
      end

      break
    end
  end
end

When /^I wait for (?:output|stdout) to contain "([^"]*)"$/ do |expected|
  Timeout.timeout(exit_timeout) do
    loop do
      begin
        expect(last_command_started).to have_output Regexp.new(Aruba::Platform.unescape(expected, aruba.config.keep_ansi))
      rescue ExpectationError
        sleep 0.1
        retry
      end

      break
    end
  end
end

Then /^the output should be (\d+) bytes long$/ do |size|
  expect(all_output).to have_output_size size.to_i
end

Then /^the output from "([^"]*)" should( not)? contain "([^"]*)"$/ do |cmd, negated, expected|
  command = process_monitor.get_process(Platform.detect_ruby(cmd))

  if negated
    expect(command).not_to have_output Regexp.new(Regexp.escape(Aruba::Platform.unescape(expected)))
  else
    expect(command).to have_output Regexp.new(Regexp.escape(Aruba::Platform.unescape(expected)))
  end
end

Then /^the output should( not)? contain "([^"]*)"$/ do |negated, expected|
  if negated
    expect(all_commands).not_to include have_content Regexp.new(Regexp.escape(Aruba::Platform.unescape(expected)))
  else
    expect(all_commands).to include have_content Regexp.new(Regexp.escape(Aruba::Platform.unescape(expected)))
  end
end

Then /^the output should( not)? contain:$/ do |negated, expected|
  if negated
    expect(all_commands).not_to include have_content Regexp.new(Regexp.escape(Aruba::Platform.unescape(expected)))
  else
    expect(all_commands).to include have_content Regexp.new(Regexp.escape(Aruba::Platform.unescape(expected)))
  end
end

## the output should contain exactly "output"
## the output from `echo -n "Hello"` should contain exactly "Hello"
Then /^the output(?: from "(.*?)")? should( not)? contain exactly "(.*?)"$/ do |cmd, negated, expected|
  commands = if cmd
               [process_monitor.get_process(Platform.detect_ruby(cmd))]
             else
               all_commands
             end

  if negated
    expect(commands).not_to have_output Aruba::Platform.unescape(expected)
  else
    expect(commands).to have_output Aruba::Platform.unescape(expected)
  end
end

## the output should contain exactly:
## the output from `echo -n "Hello"` should contain exactly:
Then /^the output(?: from "(.*?)")? should( not)? contain exactly:$/ do |cmd, negated, expected|
  commands = if cmd
               [process_monitor.get_process(Platform.detect_ruby(cmd))]
             else
               all_commands
             end

  if negated
    expect(commands).not_to have_output Aruba::Platform.unescape(expected)
  else
    expect(commands).to have_output Aruba::Platform.unescape(expected)
  end
end

# "the output should match" allows regex in the partial_output, if
# you don't need regex, use "the output should contain" instead since
# that way, you don't have to escape regex characters that
# appear naturally in the output
Then /^the output should( not)? match \/([^\/]*)\/$/ do |negated, expected|
  if negated
    expect(all_commands).not_to include have_output Regexp.new(expected)
  else
    expect(all_commands).to include have_output Regexp.new(expected)
  end
end

Then /^the output should( not)? match %r<([^>]*)>$/ do |negated, expected|
  if negated
    expect(all_commands).not_to include have_output Regexp.new(expected)
  else
    expect(all_commands).to include have_output Regexp.new(expected)
  end
end

Then /^the output should( not)? match:$/ do |negated, expected|
  if negated
    expect(all_commands).not_to include have_output Regexp.new(expected)
  else
    expect(all_commands).to include have_output Regexp.new(expected)
  end
end

Then /^the exit (?:status|code) should( not)? be (\d+)$/ do |negated, exit_status|
  if negated
    expect(last_command_stopped).not_to have_exit_status exit_status.to_i
  else
    expect(last_command_stopped).to have_exit_status exit_status.to_i
  end
end

Then /^it should (pass|fail) with "(.*?)"$/ do |pass_fail, partial_output|
  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
    expect(last_command_stopped).to have_content Regexp.new(Regexp.escape(Aruba::Platform.unescape(expected)))
  else
    expect(last_command_stopped).not_to be_successfully_executed
    expect(last_command_stopped).to have_content Regexp.new(Regexp.escape(Aruba::Platform.unescape(expected)))
  end
end

Then /^it should (pass|fail) with:$/ do |pass_fail, partial_output|
  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
    expect(last_command_stopped).to have_content Regexp.new(Regexp.escape(Aruba::Platform.unescape(expected)))
  else
    expect(last_command_stopped).not_to be_successfully_executed
    expect(last_command_stopped).to have_content Regexp.new(Regexp.escape(Aruba::Platform.unescape(expected)))
  end
end

Then /^it should (pass|fail) with exactly:$/ do |pass_fail, exact_output|
  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
    expect(last_command_stopped).to have_content Aruba::Platform.unescape(expected)
  else
    expect(last_command_stopped).not_to be_successfully_executed
    expect(last_command_stopped).to have_content Aruba::Platform.unescape(expected)
  end
end

Then /^it should (pass|fail) with regexp?:$/ do |pass_fail, expected|
  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
    expect(last_command_stopped).to have_content Regexp.new(expected)
  else
    expect(last_command_stopped).not_to be_successfully_executed
    expect(last_command_stopped).to have_content Regexp.new(expected)
  end
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

Then /^the following files should (not )?exist:$/ do |negated, files|
  files = files.rows.flatten

  if negated
    expect(files).not_to include an_existing_file
  else
    expect(files).to all be_an_existing_file
  end
end

Then /^(?:a|the) file(?: named)? "([^"]*)" should (not )?exist$/ do |file, expect_match|
  if expect_match
    expect(file).not_to be_an_existing_file
  else
    expect(file).to be_an_existing_file
  end
end

Then /^(?:a|the) file matching %r<(.*?)> should (not )?exist$/ do |pattern, expect_match|
  if expect_match
    expect(all_paths).not_to include match Regexp.new(pattern)
  else
    expect(all_paths).to include match Regexp.new(pattern)
  end
end

Then /^(?:a|the) (\d+) byte file(?: named)? "([^"]*)" should (not )?exist$/ do |size, file, negated|
  if negated
    expect(file).not_to have_file_size(size)
  else
    expect(file).to have_file_size(size)
  end
end

Then /^the following directories should (not )?exist:$/ do |negated, directories|
  directories = directories.rows.flatten

  if negated
    expect(directories).not_to include an_existing_directory
  else
    expect(directories).to all be_an_existing_directory
  end
end

Then /^(?:a|the) directory(?: named)? "([^"]*)" should (not )?exist$/ do |directory, negated|
  if negated
    expect(directory).not_to be_an_existing_directory
  else
    expect(directory).to be_an_existing_directory
  end
end

Then /^(?:a|the) file "([^"]*)" should (not )?contain "([^"]*)"$/ do |file, negated, content|
  if negated
    expect(file).not_to have_file_content Regexp.new(Regexp.escape(content))
  else
    expect(file).to have_file_content Regexp.new(Regexp.escape(content))
  end
end

Then /^(?:a|the) file "([^"]*)" should (not )?contain:$/ do |file, negated, content|
  if negated
    expect(file).not_to have_file_content Regexp.new(Regexp.escape(content.chomp))
  else
    expect(file).to have_file_content Regexp.new(Regexp.escape(content.chomp))
  end
end

Then /^(?:a|the) file "([^"]*)" should (not )?contain exactly:$/ do |file, negated, content|
  if negated
    expect(file).not_to have_file_content content
  else
    expect(file).to have_file_content content
  end
end

Then /^(?:a|the) file "([^"]*)" should (not )?match %r<([^\/]*)>$/ do |file, negated, content|
  if negated
    expect(file).not_to have_file_content Regexp.new(content)
  else
    expect(file).to have_file_content Regexp.new(content)
  end
end

Then /^(?:a|the) file "([^"]*)" should (not )?match \/([^\/]*)\/$/ do |file, negated, content|
  if negated
    expect(file).not_to have_file_content Regexp.new(content)
  else
    expect(file).to have_file_content Regexp.new(content)
  end
end

Then /^(?:a|the) file "([^"]*)" should (not )?be equal to file "([^"]*)"/ do |file, negated, reference_file|
  if negated
    expect(file).not_to have_same_file_content_like(reference_file)
  else
    expect(file).to have_same_file_content_like(reference_file)
  end
end

Then /^the mode of filesystem object "([^"]*)" should (not )?match "([^"]*)"$/ do |file, negated, permissions|
  if negated
    expect(file).not_to have_permissions(permissions)
  else
    expect(file).to have_permissions(permissions)
  end
end
