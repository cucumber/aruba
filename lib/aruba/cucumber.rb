require 'aruba/version'

require 'aruba/api'
World(Aruba::Api)

require 'aruba/scope'
World(Aruba::Scope)

require 'aruba/cucumber/hooks'
require 'aruba/reporting'

if Aruba::VERSION >= '1.0.0'
  Aruba.configure do |config|
    config.working_directory = 'tmp/cucumber'
  end
end

Given /the default aruba timeout is (\d+) seconds/ do |seconds|
  aruba_scope do
    aruba.config.exit_timeout = seconds.to_i
  end
end

Given /I use (?:a|the) fixture(?: named)? "([^"]*)"/ do |name|
  aruba_scope do
    copy File.join(aruba.config.fixtures_path_prefix, name), name
    cd name
  end
end

Given /The default aruba timeout is (\d+) seconds/ do |seconds|
  warn(%{\e[35m    The  /^The default aruba timeout is (\d+) seconds/ step definition is deprecated. Please use the one with `the` and not `The` at the beginning.\e[0m})
  aruba_scope do
    aruba.config.exit_timeout = seconds.to_i
  end
end

Given /^I'm using a clean gemset "([^"]*)"$/ do |gemset|
  aruba_scope do
    use_clean_gemset(gemset)
  end
end

Given /^(?:a|the) directory(?: named)? "([^"]*)"$/ do |dir_name|
  aruba_scope do
    create_directory(dir_name)
  end
end

Given /^(?:a|the) directory(?: named)? "([^"]*)" with mode "([^"]*)"$/ do |dir_name, dir_mode|
  aruba_scope do
    create_directory(dir_name)
    chmod(dir_mode, dir_name)
  end
end

Given /^(?:a|the) file(?: named)? "([^"]*)" with:$/ do |file_name, file_content|
  aruba_scope do
    write_file(file_name, file_content)
  end
end

Given /^(?:a|the) file(?: named)? "([^"]*)" with mode "([^"]*)" and with:$/ do |file_name, file_mode, file_content|
  aruba_scope do
    write_file(file_name, file_content)
    chmod(file_mode, file_name)
  end
end

Given /^(?:a|the) (\d+) byte file(?: named)? "([^"]*)"$/ do |file_size, file_name|
  aruba_scope do
    write_fixed_size_file(file_name, file_size.to_i)
  end
end

Given /^(?:an|the) empty file(?: named)? "([^"]*)"$/ do |file_name|
  aruba_scope do
    write_file(file_name, "")
  end
end

Given /^(?:an|the) empty file(?: named)? "([^"]*)" with mode "([^"]*)"$/ do |file_name, file_mode|
  aruba_scope do
    write_file(file_name, "")
    chmod(file_mode, file_name)
  end
end

Given /^a mocked home directory$/ do
  aruba_scope do
    set_environment_variable 'HOME', expand_path('.')
  end
end

Given /^(?:a|the) directory(?: named)? "([^"]*)" does not exist$/ do |directory_name|
  aruba_scope do
    remove(directory_name, :force => true)
  end
end

When /^I write to "([^"]*)" with:$/ do |file_name, file_content|
  aruba_scope do
    write_file(file_name, file_content)
  end
end

When /^I overwrite "([^"]*)" with:$/ do |file_name, file_content|
  aruba_scope do
    overwrite_file(file_name, file_content)
  end
end

When /^I append to "([^"]*)" with:$/ do |file_name, file_content|
  aruba_scope do
    append_to_file(file_name, file_content)
  end
end

When /^I append to "([^"]*)" with "([^"]*)"$/ do |file_name, file_content|
  aruba_scope do
    append_to_file(file_name, file_content)
  end
end

When /^I remove (?:a|the) file(?: named)? "([^"]*)"$/ do |file_name|
  aruba_scope do
    remove(file_name)
  end
end

Given /^(?:a|the) file(?: named)? "([^"]*)" does not exist$/ do |file_name|
  aruba_scope do
    remove(file_name, :force => true)
  end
end

When(/^I remove (?:a|the) directory(?: named)? "(.*?)"$/) do |directory_name|
  aruba_scope do
    remove(directory_name)
  end
end

When /^I cd to "([^"]*)"$/ do |dir|
  aruba_scope do
    cd(dir)
  end
end

Given /^I set the environment variables to:/ do |table|
  aruba_scope do
    table.hashes.each do |row|
      variable = row['variable'].to_s.upcase
      value = row['value'].to_s

      set_environment_variable(variable, value)
    end
  end
end

Given /^I append the value to the environment variable:/ do |table|
  aruba_scope do
    table.hashes.each do |row|
      variable = row['variable'].to_s.upcase
      value = row['value'].to_s

      append_environment_variable(variable, value)
    end
  end
end

When /^I run "(.*)"$/ do |cmd|
  warn(%{\e[35m    The /^I run "(.*)"$/ step definition is deprecated. Please use the `backticks` version\e[0m})
  aruba_scope do
    run_simple(Aruba::Platform.unescape(cmd, aruba.config.keep_ansi), false)
  end
end

When /^I run `([^`]*)`$/ do |cmd|
  aruba_scope do
    run_simple(Aruba::Platform.unescape(cmd, aruba.config.keep_ansi), false)
  end
end

When /^I successfully run "(.*)"$/ do |cmd|
  warn(%{\e[35m    The  /^I successfully run "(.*)"$/ step definition is deprecated. Please use the `backticks` version\e[0m})
  aruba_scope do
    run_simple(Aruba::Platform.unescape(cmd, aruba.config.keep_ansi))
  end
end

## I successfully run `echo -n "Hello"`
## I successfully run `sleep 29` for up to 30 seconds
When /^I successfully run `(.*?)`(?: for up to (\d+) seconds)?$/ do |cmd, secs|
  aruba_scope do
    run_simple(Aruba::Platform.unescape(cmd, aruba.config.keep_ansi), true, secs && secs.to_i)
  end
end

When /^I run "([^"]*)" interactively$/ do |cmd|
  aruba_scope do
    warn(%{\e[35m    The /^I run "([^"]*)" interactively$/ step definition is deprecated. Please use the `backticks` version\e[0m})
    step %(I run `#{cmd}` interactively)
  end
end

When /^I run `([^`]*)` interactively$/ do |cmd|
  aruba_scope do
    @interactive = run(Aruba::Platform.unescape(cmd, aruba.config.keep_ansi))
  end
end

When /^I type "([^"]*)"$/ do |input|
  aruba_scope do
    type(input)
  end
end

When /^I close the stdin stream$/ do
  aruba_scope do
    close_input
  end
end

When /^I pipe in (?:a|the) file(?: named)? "([^"]*)"$/ do |file|
  aruba_scope do
    pipe_in_file(file)

    close_input
  end
end

When /^I wait for (?:output|stdout) to contain "([^"]*)"$/ do |expected|
  aruba_scope do
    Timeout.timeout(exit_timeout) do
      loop do
        break if assert_partial_output_interactive(expected)
        sleep 0.1
      end
    end
  end
end

Then /^the output should contain "([^"]*)"$/ do |expected|
  aruba_scope do
    assert_partial_output(expected, all_output)
  end
end

Then /^the output from "([^"]*)" should contain "([^"]*)"$/ do |cmd, expected|
  aruba_scope do
    assert_partial_output(expected, output_from(cmd))
  end
end

Then /^the output from "([^"]*)" should not contain "([^"]*)"$/ do |cmd, unexpected|
  aruba_scope do
    assert_no_partial_output(unexpected, output_from(cmd))
  end
end

Then /^the output should not contain "([^"]*)"$/ do |unexpected|
  aruba_scope do
    assert_no_partial_output(unexpected, all_output)
  end
end

Then /^the output should contain:$/ do |expected|
  aruba_scope do
    assert_partial_output(expected, all_output)
  end
end

Then /^the output should not contain:$/ do |unexpected|
  aruba_scope do
    assert_no_partial_output(unexpected, all_output)
  end
end

## the output should contain exactly "output"
## the output from `echo -n "Hello"` should contain exactly "Hello"
Then /^the output(?: from "(.*?)")? should contain exactly "(.*?)"$/ do |cmd, expected|
  aruba_scope do
    assert_exact_output(expected, cmd ? output_from(cmd) : all_output)
  end
end

## the output should contain exactly:
## the output from `echo -n "Hello"` should contain exactly:
Then /^the output(?: from "(.*?)")? should contain exactly:$/ do |cmd, expected|
  aruba_scope do
    assert_exact_output(expected, cmd ? output_from(cmd) : all_output)
  end
end

# "the output should match" allows regex in the partial_output, if
# you don't need regex, use "the output should contain" instead since
# that way, you don't have to escape regex characters that
# appear naturally in the output
Then /^the output should match \/([^\/]*)\/$/ do |expected|
  aruba_scope do
    assert_matching_output(expected, all_output)
  end
end

Then /^the output should match %r<([^>]*)>$/ do |expected|
  aruba_scope do
    assert_matching_output(expected, all_output)
  end
end

Then /^the output should match:$/ do |expected|
  aruba_scope do
    assert_matching_output(expected, all_output)
  end
end

# The previous two steps antagonists
Then /^the output should not match \/([^\/]*)\/$/ do |expected|
  aruba_scope do
    assert_not_matching_output(expected, all_output)
  end
end

Then /^the output should not match:$/ do |expected|
  aruba_scope do
    assert_not_matching_output(expected, all_output)
  end
end

Then /^the exit status should be (\d+)$/ do |exit_status|
  aruba_scope do
    assert_exit_status(exit_status.to_i)
  end
end

Then /^the exit status should not be (\d+)$/ do |exit_status|
  aruba_scope do
    assert_not_exit_status(exit_status.to_i)
  end
end

Then /^it should (pass|fail) with:$/ do |pass_fail, partial_output|
  aruba_scope do
    self.__send__("assert_#{pass_fail}ing_with", partial_output)
  end
end

Then /^it should (pass|fail) with exactly:$/ do |pass_fail, exact_output|
  aruba_scope do
    assert_exit_status_and_output(pass_fail == "pass", exact_output, true)
  end
end

Then /^it should (pass|fail) with regexp?:$/ do |pass_fail, expected|
  aruba_scope do
    assert_matching_output(expected, all_output)
    assert_success(pass_fail == 'pass')
  end
end

## the stderr should contain "hello"
## the stderr from "echo -n 'Hello'" should contain "hello"
## the stderr should contain exactly:
## the stderr from "echo -n 'Hello'" should contain exactly:
Then /^the stderr(?: from "(.*?)")? should contain( exactly)? "(.*?)"$/ do |cmd, exact, expected|
  aruba_scope do
    if exact
      assert_exact_output(expected, cmd ? stderr_from(cmd) : all_stderr)
    else
      assert_partial_output(expected, cmd ? stderr_from(cmd) : all_stderr)
    end
  end
end

## the stderr should contain:
## the stderr from "echo -n 'Hello'" should contain:
## the stderr should contain exactly:
## the stderr from "echo -n 'Hello'" should contain exactly:
Then /^the stderr(?: from "(.*?)")? should contain( exactly)?:$/ do |cmd, exact, expected|
  aruba_scope do
    if exact
      assert_exact_output(expected, cmd ? stderr_from(cmd) : all_stderr)
    else
      assert_partial_output(expected, cmd ? stderr_from(cmd) : all_stderr)
    end
  end
end

## the stdout should contain "hello"
## the stdout from "echo -n 'Hello'" should contain "hello"
## the stdout should contain exactly:
## the stdout from "echo -n 'Hello'" should contain exactly:
Then /^the stdout(?: from "(.*?)")? should contain( exactly)? "(.*?)"$/ do |cmd, exact, expected|
  aruba_scope do
    if exact
      assert_exact_output(expected, cmd ? stdout_from(cmd) : all_stdout)
    else
      assert_partial_output(expected, cmd ? stdout_from(cmd) : all_stdout)
    end
  end
end

## the stdout should contain:
## the stdout from "echo -n 'Hello'" should contain:
## the stdout should contain exactly:
## the stdout from "echo -n 'Hello'" should contain exactly:
Then /^the stdout(?: from "(.*?)")? should contain( exactly)?:$/ do |cmd, exact, expected|
  aruba_scope do
    if exact
      assert_exact_output(expected, cmd ? stdout_from(cmd) : all_stdout)
    else
      assert_partial_output(expected, cmd ? stdout_from(cmd) : all_stdout)
    end
  end
end

Then /^the stderr should not contain "([^"]*)"$/ do |unexpected|
  aruba_scope do
    assert_no_partial_output(unexpected, all_stderr)
  end
end

Then /^the stderr should not contain:$/ do |unexpected|
  aruba_scope do
    assert_no_partial_output(unexpected, all_stderr)
  end
end

Then /^the (stderr|stdout) should not contain anything$/ do |stream_name|
  aruba_scope do
    stream = self.send("all_#{stream_name}")
    expect(stream).to be_empty
  end
end

Then /^the stdout should not contain "([^"]*)"$/ do |unexpected|
  aruba_scope do
    assert_no_partial_output(unexpected, all_stdout)
  end
end

Then /^the stdout should not contain:$/ do |unexpected|
  aruba_scope do
    assert_no_partial_output(unexpected, all_stdout)
  end
end

Then /^the stdout from "([^"]*)" should not contain "([^"]*)"$/ do |cmd, unexpected|
  aruba_scope do
    assert_no_partial_output(unexpected, stdout_from(cmd))
  end
end

Then /^the stderr from "([^"]*)" should not contain "([^"]*)"$/ do |cmd, unexpected|
  aruba_scope do
    assert_no_partial_output(unexpected, stderr_from(cmd))
  end
end

Then /^the following files should (not )?exist:$/ do |negated, files|
  files = files.rows.flatten

  aruba_scope do
    if negated
      expect(files).not_to include an_existing_file
    else
      expect(files).to all be_an_existing_file
    end
  end
end

Then /^(?:a|the) file(?: named)? "([^"]*)" should (not )?exist$/ do |file, expect_match|
  aruba_scope do
    if expect_match
      expect(file).not_to be_an_existing_file
    else
      expect(file).to be_an_existing_file
    end
  end
end

Then /^(?:a|the) file matching %r<(.*?)> should (not )?exist$/ do |pattern, expect_match|
  aruba_scope do
    if expect_match
      expect(all_paths).not_to include match Regexp.new(pattern)
    else
      expect(all_paths).to include match Regexp.new(pattern)
    end
  end
end

Then /^(?:a|the) (\d+) byte file(?: named)? "([^"]*)" should (not )?exist$/ do |size, file, negated|
  aruba_scope do
    if negated
      expect(file).not_to have_file_size(size)
    else
      expect(file).to have_file_size(size)
    end
  end
end

Then /^the following directories should (not )?exist:$/ do |negated, directories|
  directories = directories.rows.flatten

  aruba_scope do
    if negated
      expect(directories).not_to include an_existing_directory
    else
      expect(directories).to all be_an_existing_directory
    end
  end
end

Then /^(?:a|the) directory(?: named)? "([^"]*)" should (not )?exist$/ do |directory, negated|
  aruba_scope do
    if negated
      expect(directory).not_to be_an_existing_directory
    else
      expect(directory).to be_an_existing_directory
    end
  end
end

Then /^(?:a|the) file "([^"]*)" should (not )?contain "([^"]*)"$/ do |file, negated, content|
  aruba_scope do
    if negated
      expect(file).not_to have_file_content Regexp.new(Regexp.escape(content))
    else
      expect(file).to have_file_content Regexp.new(Regexp.escape(content))
    end
  end
end

Then /^(?:a|the) file "([^"]*)" should (not )?contain:$/ do |file, negated, content|
  aruba_scope do
    if negated
      expect(file).not_to have_file_content Regexp.new(Regexp.escape(content.chomp))
    else
      expect(file).to have_file_content Regexp.new(Regexp.escape(content.chomp))
    end
  end
end

Then /^(?:a|the) file "([^"]*)" should (not )?contain exactly:$/ do |file, negated, content|
  aruba_scope do
    if negated
      expect(file).not_to have_file_content content
    else
      expect(file).to have_file_content content
    end
  end
end

Then /^(?:a|the) file "([^"]*)" should (not )?match %r<([^\/]*)>$/ do |file, negated, content|
  aruba_scope do
    if negated
      expect(file).not_to have_file_content Regexp.new(content)
    else
      expect(file).to have_file_content Regexp.new(content)
    end
  end
end

Then /^(?:a|the) file "([^"]*)" should (not )?match \/([^\/]*)\/$/ do |file, negated, content|
  aruba_scope do
    if negated
      expect(file).not_to have_file_content Regexp.new(content)
    else
      expect(file).to have_file_content Regexp.new(content)
    end
  end
end

Then /^(?:a|the) file "([^"]*)" should (not )?be equal to file "([^"]*)"/ do |file, negated, reference_file|
  aruba_scope do
    if negated
      expect(file).not_to have_same_file_content_like(reference_file)
    else
      expect(file).to have_same_file_content_like(reference_file)
    end
  end
end

Then /^the mode of filesystem object "([^"]*)" should (not )?match "([^"]*)"$/ do |file, negated, permissions|
  aruba_scope do
    if negated
      expect(file).not_to have_permissions(permissions)
    else
      expect(file).to have_permissions(permissions)
    end
  end
end
