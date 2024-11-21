# frozen_string_literal: true

require 'aruba/generators/script_file'

When 'I run {command}' do |cmd|
  cmd = sanitize_text(cmd)
  run_command_and_stop(cmd, fail_on_error: false)
end

When 'I successfully run {command}' do |cmd|
  cmd = sanitize_text(cmd)
  run_command_and_stop(cmd, fail_on_error: true)
end

When 'I successfully run {command} for up to {float} seconds' do |cmd, secs|
  cmd = sanitize_text(cmd)
  run_command_and_stop(cmd, fail_on_error: true, exit_timeout: secs.to_f)
end

When 'I run the following commands:/script:' do |commands|
  full_path = expand_path('bin/myscript')

  Aruba.platform.mkdir(expand_path('bin'))
  shell = Aruba.platform.default_shell

  Aruba::ScriptFile.new(interpreter: shell, content: commands, path: full_path).call
  run_command_and_stop(Shellwords.escape(full_path), fail_on_error: false)
end

When 'I run the following commands/script with/in {command}:' do |shell, commands|
  full_path = expand_path('bin/myscript')

  Aruba.platform.mkdir(expand_path('bin'))

  Aruba::ScriptFile.new(interpreter: shell, content: commands, path: full_path).call
  run_command_and_stop(Shellwords.escape(full_path), fail_on_error: false)
end

When 'I run {command} interactively' do |cmd|
  run_command(sanitize_text(cmd))
end

# Merge interactive and background after refactoring with event queue
When 'I run {command} in background' do |cmd|
  run_command(sanitize_text(cmd))
end

When 'I type {string}' do |input|
  type(unescape_text(input))
end

When 'I close the stdin stream' do
  close_input
end

When 'I pipe in a/the file( named) {string}' do |file|
  pipe_in_file(file)

  close_input
end

When 'I stop the command started last' do
  last_command_started.stop
end

When 'I stop the command {string}' do |command|
  aruba.command_monitor.find(command).stop
end

When 'I terminate the command started last' do
  last_command_started.terminate
end

When 'I terminate the command {string}' do |command|
  aruba.command_monitor.find(command).terminate
end

When(/^I stop the command(?: started last)? if (output|stdout|stderr) contains:$/) \
  do |channel, expected|

  Timeout.timeout(aruba.config.exit_timeout) do
    loop do
      output = last_command_started.public_send channel.to_sym, wait_for_io: 0

      output   = sanitize_text(output)
      expected = sanitize_text(expected)

      if output.include? expected
        last_command_started.terminate

        break
      end

      sleep 0.1
    end
  end
rescue Timeout::Error
  last_command_started.terminate
end

When 'I wait for output/stdout to contain:' do |expected|
  Timeout.timeout(aruba.config.exit_timeout) do
    loop do
      output = last_command_started.stdout wait_for_io: 0

      output   = sanitize_text(output)
      expected = sanitize_text(expected)

      break if output.include? expected

      sleep 0.1
    end
  end
end

When 'I wait for output/stdout to contain {string}' do |expected|
  Timeout.timeout(aruba.config.exit_timeout) do
    loop do
      output = last_command_started.stdout wait_for_io: 0

      output   = sanitize_text(output)
      expected = sanitize_text(expected)

      break if output.include? expected

      sleep 0.1
    end
  end
end

Then 'the output should be {int} bytes long' do |size|
  expect(last_command_started).to have_output_size size.to_i
end

## the stderr should contain "hello"
Then '(the ){channel} should contain {string}' do |channel, expected|
  combined_output = send(:"all_#{channel}")

  expect(combined_output).to include_output_string expected
end

## the stderr should not contain "hello"
Then '(the ){channel} should not contain {string}' do |channel, expected|
  combined_output = send(:"all_#{channel}")

  expect(combined_output).not_to include_output_string expected
end

## the stderr should contain exactly "hello"
Then '(the ){channel} should contain exactly {string}' do |channel, expected|
  combined_output = send(:"all_#{channel}")

  expect(combined_output).to output_string_eq expected
end

## the stderr should not contain exactly "hello"
Then '(the ){channel} should not contain exactly {string}' do |channel, expected|
  combined_output = send(:"all_#{channel}")

  expect(combined_output).not_to output_string_eq expected
end

## the stderr from "echo -n 'Hello'" should contain "hello"
Then '(the ){channel} from {string} should contain {string}' do |channel, cmd, expected|
  matcher = case channel
            when 'output'; then :have_output
            when 'stderr'; then :have_output_on_stderr
            when 'stdout'; then :have_output_on_stdout
            end

  command = aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd))

  output_string_matcher = :an_output_string_including

  expect(command).to send(matcher, send(output_string_matcher, expected))
end

## the stderr from "echo -n 'Hello'" should contain exactly "hello"
Then '(the ){channel} from {string} should contain exactly {string}' \
  do |channel, cmd, expected|
  matcher = case channel
            when 'output'; then :have_output
            when 'stderr'; then :have_output_on_stderr
            when 'stdout'; then :have_output_on_stdout
            end

  command = aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd))

  output_string_matcher = :an_output_string_being_eq

  expect(command).to send(matcher, send(output_string_matcher, expected))
end

## the stderr from "echo -n 'Hello'" should not contain "hello"
Then '(the ){channel} from {string} should not contain {string}' do |channel, cmd, expected|
  matcher = case channel
            when 'output'; then :have_output
            when 'stderr'; then :have_output_on_stderr
            when 'stdout'; then :have_output_on_stdout
            end

  command = aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd))

  output_string_matcher = :an_output_string_including

  expect(command).not_to send(matcher, send(output_string_matcher, expected))
end

## the stderr from "echo -n 'Hello'" should not contain exactly "hello"
Then '(the ){channel} from {string} should not contain exactly {string}' \
  do |channel, cmd, expected|
  matcher = case channel
            when 'output'; then :have_output
            when 'stderr'; then :have_output_on_stderr
            when 'stdout'; then :have_output_on_stdout
            end

  command = aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd))

  output_string_matcher = :an_output_string_being_eq

  expect(command).not_to send(matcher, send(output_string_matcher, expected))
end

## the stderr should contain:
Then '(the ){channel} should contain:' do |channel, expected|
  combined_output = send(:"all_#{channel}")

  expect(combined_output).to include_output_string(expected)
end

## the stderr should not contain:
Then '(the ){channel} should not contain:' do |channel, expected|
  combined_output = send(:"all_#{channel}")

  expect(combined_output).not_to include_output_string(expected)
end

## the stderr should contain exactly:
Then '(the ){channel} should contain exactly:' do |channel, expected|
  combined_output = send(:"all_#{channel}")

  expect(combined_output).to output_string_eq(expected)
end

## the stderr should not contain exactly:
Then '(the ){channel} should not contain exactly:' do |channel, expected|
  combined_output = send(:"all_#{channel}")

  expect(combined_output).not_to output_string_eq(expected)
end

## the stderr from "echo -n 'Hello'" should not contain:
Then '(the ){channel} from {string} should not contain:' do |channel, cmd, expected|
  matcher = case channel
            when 'output'; then :have_output
            when 'stderr'; then :have_output_on_stderr
            when 'stdout'; then :have_output_on_stdout
            end

  command = aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd))

  output_string_matcher = :an_output_string_including

  expect(command).not_to send(matcher, send(output_string_matcher, expected))
end

## the stderr from "echo -n 'Hello'" should not contain exactly:
Then '(the ){channel} from {string} should not contain exactly:' do |channel, cmd, expected|
  matcher = case channel
            when 'output'; then :have_output
            when 'stderr'; then :have_output_on_stderr
            when 'stdout'; then :have_output_on_stdout
            end

  command = aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd))

  output_string_matcher = :an_output_string_being_eq

  expect(command).not_to send(matcher, send(output_string_matcher, expected))
end

## the stderr from "echo -n 'Hello'" should contain:
Then '(the ){channel} from {string} should contain:' do |channel, cmd, expected|
  matcher = case channel
            when 'output'; then :have_output
            when 'stderr'; then :have_output_on_stderr
            when 'stdout'; then :have_output_on_stdout
            end

  command = aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd))

  output_string_matcher = :an_output_string_including

  expect(command).to send(matcher, send(output_string_matcher, expected))
end

## the stderr from "echo -n 'Hello'" should contain exactly:
Then '(the ){channel} from {string} should contain exactly:' do |channel, cmd, expected|
  matcher = case channel
            when 'output'; then :have_output
            when 'stderr'; then :have_output_on_stderr
            when 'stdout'; then :have_output_on_stdout
            end

  command = aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd))

  output_string_matcher = :an_output_string_being_eq

  expect(command).to send(matcher, send(output_string_matcher, expected))
end

# "the output should match" allows regex in the partial_output, if
# you don't need regex, use "the output should contain" instead since
# that way, you don't have to escape regex characters that
# appear naturally in the output
Then(%r{^the output should( not)? match /([^/]*)/$}) do |negated, expected|
  if negated
    expect(all_commands)
      .not_to include have_output an_output_string_matching(expected)
  else
    expect(all_commands)
      .to include have_output an_output_string_matching(expected)
  end
end

Then(/^the output should( not)? match %r<([^>]*)>$/) do |negated, expected|
  if negated
    expect(all_commands)
      .not_to include have_output an_output_string_matching(expected)
  else
    expect(all_commands)
      .to include have_output an_output_string_matching(expected)
  end
end

Then(/^the output should( not)? match:$/) do |negated, expected|
  if negated
    expect(all_commands)
      .not_to include have_output an_output_string_matching(expected)
  else
    expect(all_commands)
      .to include have_output an_output_string_matching(expected)
  end
end

Then(/^the exit status should( not)? be (\d+)$/) do |negated, exit_status|
  last_command_started.stop if last_command_stopped.empty?

  if negated
    expect(last_command_stopped).not_to have_exit_status exit_status.to_i
  else
    expect(last_command_stopped).to have_exit_status exit_status.to_i
  end
end

Then(/^it should not (pass|fail) with "(.*?)"$/) do |pass_fail, expected|
  last_command_started.stop

  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
  else
    expect(last_command_stopped).not_to be_successfully_executed
  end

  expect(last_command_stopped).not_to have_output an_output_string_including(expected)
end

Then(/^it should (pass|fail) with "(.*?)"$/) do |pass_fail, expected|
  last_command_started.stop

  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
  else
    expect(last_command_stopped).not_to be_successfully_executed
  end

  expect(last_command_stopped).to have_output an_output_string_including(expected)
end

Then(/^it should not (pass|fail) with:$/) do |pass_fail, expected|
  last_command_started.stop

  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
  else
    expect(last_command_stopped).not_to be_successfully_executed
  end

  expect(last_command_stopped).not_to have_output an_output_string_including(expected)
end

Then(/^it should (pass|fail) with:$/) do |pass_fail, expected|
  last_command_started.stop

  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
  else
    expect(last_command_stopped).not_to be_successfully_executed
  end

  expect(last_command_stopped).to have_output an_output_string_including(expected)
end

Then(/^it should not (pass|fail) with exactly:$/) do |pass_fail, expected|
  last_command_started.stop

  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
  else
    expect(last_command_stopped).not_to be_successfully_executed
  end

  expect(last_command_stopped).not_to have_output an_output_string_eq(expected)
end

Then(/^it should (pass|fail) with exactly:$/) do |pass_fail, expected|
  last_command_started.stop

  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
  else
    expect(last_command_stopped).not_to be_successfully_executed
  end

  expect(last_command_stopped.output).to output_string_eq(expected)
end

Then(/^it should not (pass|fail) (?:with regexp?|matching):$/) do |pass_fail, expected|
  last_command_started.stop

  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
  else
    expect(last_command_stopped).not_to be_successfully_executed
  end

  expect(last_command_stopped).not_to have_output an_output_string_matching(expected)
end

Then(/^it should (pass|fail) (?:with regexp?|matching):$/) do |pass_fail, expected|
  last_command_started.stop

  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
  else
    expect(last_command_stopped).not_to be_successfully_executed
  end

  expect(last_command_stopped).to have_output an_output_string_matching(expected)
end

Then '(the ){channel} should not contain anything' do |channel|
  combined_output = send(:"all_#{channel}")

  expect(combined_output).to output_string_eq ''
end

Then(/^(?:the )?(output|stdout|stderr) should( not)? contain all of these lines:$/) \
  do |channel, negated, table|
  table.raw.flatten.each do |expected|
    _matcher = case channel
               when 'output'; then :have_output
               when 'stderr'; then :have_output_on_stderr
               when 'stdout'; then :have_output_on_stdout
               end

    # TODO: This isn't actually using the above. It's hardcoded to use have_output only

    if negated
      expect(all_commands)
        .not_to include have_output an_output_string_including(expected)
    else
      expect(all_commands)
        .to include have_output an_output_string_including(expected)
    end
  end
end

Given(/^the (?:default )?aruba io wait timeout is ([\d.]+) seconds?$/) do |seconds|
  aruba.config.io_wait_timeout = seconds.to_f
end

Given(/^the (?:default )?aruba exit timeout is ([\d.]+) seconds?$/) do |seconds|
  aruba.config.exit_timeout = seconds.to_f
end

Given 'the( default) aruba stop signal is {string}' do |signal|
  aruba.config.stop_signal = signal
end

Given(/^I wait ([\d.]+) seconds? for (?:a|the) command to start up$/) do |seconds|
  aruba.config.startup_wait_time = seconds.to_f
end

When 'I send the signal {string} to the command {string}' do |signal, command|
  cmd = all_commands.find { |c| c.commandline == command }
  raise ArgumentError, %(No command "#{command}" found) if cmd.nil?

  cmd.send_signal signal
end

When 'I send the signal {string} to the command started last' do |signal|
  last_command_started.send_signal signal
end

Given 'I look for executables in {string} within the current directory' do |directory|
  prepend_environment_variable 'PATH', expand_path(directory) + File::PATH_SEPARATOR
end
