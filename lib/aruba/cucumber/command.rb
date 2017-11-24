if Aruba::VERSION < '1.0.0'
  require 'aruba/cucumber/core'
end
require 'aruba/generators/script_file'

When(/^I run "(.*)"$/)do |cmd|
  warn(%{\e[35m    The /^I run "(.*)"$/ step definition is deprecated. Please use the `backticks` version\e[0m})

  cmd = sanitize_text(cmd)
  run_simple(cmd, false)
end

When(/^I run `([^`]*)`$/)do |cmd|
  cmd = sanitize_text(cmd)
  run_simple(cmd, :fail_on_error => false)
end

When(/^I successfully run "(.*)"$/)do |cmd|
  warn(%{\e[35m    The  /^I successfully run "(.*)"$/ step definition is deprecated. Please use the `backticks` version\e[0m})

  cmd = sanitize_text(cmd)
  run_simple(cmd)
end

## I successfully run `echo -n "Hello"`
## I successfully run `sleep 29` for up to 30 seconds
When(/^I successfully run `(.*?)`(?: for up to (\d+) seconds)?$/)do |cmd, secs|
  cmd = sanitize_text(cmd)
  run_simple(cmd, :fail_on_error => true, :exit_timeout => secs && secs.to_i)
end

When(/^I run the following (?:commands|script)(?: (?:with|in) `([^`]+)`)?:$/) do |shell, commands|
  prepend_environment_variable('PATH', expand_path('bin') + File::PATH_SEPARATOR)

  Aruba.platform.mkdir(expand_path('bin'))
  shell ||= Aruba.platform.default_shell

  Aruba::ScriptFile.new(:interpreter => shell, :content => commands,
                        :path => expand_path('bin/myscript')).call
  step 'I run `myscript`'
end

When(/^I run "([^"]*)" interactively$/) do |cmd|
  Aruba.platform.deprecated(%{\e[35m    The /^I run "([^"]*)" interactively$/ step definition is deprecated. Please use the `backticks` version\e[0m})

  step %(I run `#{cmd}` interactively)
end

When(/^I run `([^`]*)` interactively$/)do |cmd|
  cmd = sanitize_text(cmd)
  @interactive = run(cmd)
end

# Merge interactive and background after refactoring with event queue
When(/^I run `([^`]*)` in background$/)do |cmd|
  run(sanitize_text(cmd))
end

When(/^I type "([^"]*)"$/) do |input|
  type(unescape_text(input))
end

When(/^I close the stdin stream$/) do
  close_input
end

When(/^I pipe in (?:a|the) file(?: named)? "([^"]*)"$/) do |file|
  pipe_in_file(file)

  close_input
end

When(/^I (terminate|stop) the command (?:"([^"]*)"|(?:started last))$/) do |signal, command|
  if command
    cmd = all_commands.find { |c| c.commandline == command }
    fail ArgumentError, %(No command "#{command}" found) if cmd.nil?

    if signal == 'terminate'
      # last_command_started.terminate
      process_monitor.terminate_process!(process_monitor.get_process(command))
    else
      # last_command_started.stop
      process_monitor.stop_process(process_monitor.get_process(command))
    end
  else
    if signal == 'terminate'
      # last_command_started.terminate
      process_monitor.terminate_process!(last_command_started)
    else
      # last_command_started.stop
      process_monitor.stop_process(last_command_started)
    end
  end
end

When(/^I stop the command(?: started last)? if (output|stdout|stderr) contains:$/) do |channel, expected|
  fail %(Invalid output channel "#{channel}" chosen. Please choose one of "output, stdout or stderr") unless %w(output stdout stderr).include? channel

  begin
    Timeout.timeout(aruba.config.exit_timeout) do
      loop do
        output = if RUBY_VERSION < '1.9.3'
                   last_command_started.send channel.to_sym, :wait_for_io => 0
                 else
                   last_command_started.public_send channel.to_sym, :wait_for_io => 0
                 end

        output   = sanitize_text(output)
        expected = sanitize_text(expected)

        if output.include? expected
          last_command_started.terminate

          break
        end

        sleep 0.1
      end
    end
  rescue ChildProcess::TimeoutError, TimeoutError
    last_command_started.terminate
  end
end

When(/^I wait for (?:output|stdout) to contain:$/) do |expected|
  Timeout.timeout(aruba.config.exit_timeout) do
    loop do
      begin
        expect(last_command_started).to have_output an_output_string_including(expected)
      rescue ExpectationError
        sleep 0.1
        retry
      end

      break
    end
  end
end

When(/^I wait for (?:output|stdout) to contain "([^"]*)"$/) do |expected|
  Timeout.timeout(aruba.config.exit_timeout) do
    loop do
      begin
        expect(last_command_started).to have_output an_output_string_including(expected)
      rescue ExpectationError
        sleep 0.1
        retry
      end

      break
    end
  end
end

Then(/^the output should be (\d+) bytes long$/) do |size|
  expect(last_command_started.output).to have_output_size size.to_i
end

Then(/^(?:the )?(output|stderr|stdout)(?: from "([^"]*)")? should( not)? contain( exactly)? "([^"]*)"$/) do |channel, cmd, negated, exactly, expected|
  matcher = case channel.to_sym
            when :output
              :have_output
            when :stderr
              :have_output_on_stderr
            when :stdout
              :have_output_on_stdout
            end

  commands = if cmd
               [aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd))]
             else
               all_commands
             end

  output_string_matcher = if exactly
                            :an_output_string_being_eq
                          else
                            :an_output_string_including
                          end

  if Aruba::VERSION < '1.0'
    combined_output = commands.map do |c|
      c.stop
      c.send(channel.to_sym).chomp
    end.join("\n")

    if negated
      expect(combined_output).not_to send(output_string_matcher, expected)
    else
      expect(combined_output).to send(output_string_matcher, expected)
    end
  else
    if negated
      expect(commands).not_to include_an_object send(matcher, send(output_string_matcher, expected))
    else
      expect(commands).to include_an_object send(matcher, send(output_string_matcher, expected))
    end
  end
end

## the stderr should contain "hello"
## the stderr from "echo -n 'Hello'" should contain "hello"
## the stderr should contain exactly:
## the stderr from "echo -n 'Hello'" should contain exactly:
Then(/^(?:the )?(output|stderr|stdout)(?: from "([^"]*)")? should( not)? contain( exactly)?:$/) do |channel, cmd, negated, exactly, expected|
  matcher = case channel.to_sym
            when :output
              :have_output
            when :stderr
              :have_output_on_stderr
            when :stdout
              :have_output_on_stdout
            else
              fail ArgumentError, %(Invalid channel "#{channel}" chosen. Only "output", "stderr" or "stdout" are allowed.)
            end

  commands = if cmd
               [aruba.command_monitor.find(Aruba.platform.detect_ruby(cmd))]
             else
               all_commands
             end

  output_string_matcher = if exactly
                            :an_output_string_being_eq
                          else
                            :an_output_string_including
                          end

  if Aruba::VERSION < '1.0'
    combined_output = commands.map do |c|
      c.stop
      c.send(channel.to_sym).chomp
    end.join("\n")

    if negated
      expect(combined_output).not_to send(output_string_matcher, expected)
    else
      expect(combined_output).to send(output_string_matcher, expected)
    end
  else
    if negated
      expect(commands).not_to include_an_object send(matcher, send(output_string_matcher, expected))
    else
      expect(commands).to include_an_object send(matcher, send(output_string_matcher, expected))
    end
  end
end

# "the output should match" allows regex in the partial_output, if
# you don't need regex, use "the output should contain" instead since
# that way, you don't have to escape regex characters that
# appear naturally in the output
Then(/^the output should( not)? match \/([^\/]*)\/$/) do |negated, expected|
  if negated
    expect(all_commands).not_to include_an_object have_output an_output_string_matching(expected)
  else
    expect(all_commands).to include_an_object have_output an_output_string_matching(expected)
  end
end

Then(/^the output should( not)? match %r<([^>]*)>$/) do |negated, expected|
  if negated
    expect(all_commands).not_to include_an_object have_output an_output_string_matching(expected)
  else
    expect(all_commands).to include_an_object have_output an_output_string_matching(expected)
  end
end

Then(/^the output should( not)? match:$/) do |negated, expected|
  if negated
    expect(all_commands).not_to include_an_object have_output an_output_string_matching(expected)
  else
    expect(all_commands).to include_an_object have_output an_output_string_matching(expected)
  end
end

Then(/^the exit status should( not)? be (\d+)$/) do |negated, exit_status|
  if negated
    expect(last_command_stopped).not_to have_exit_status exit_status.to_i
  else
    expect(last_command_stopped).to have_exit_status exit_status.to_i
  end
end

Then(/^it should( not)? (pass|fail) with "(.*?)"$/) do |negated, pass_fail, expected|
  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
  else
    expect(last_command_stopped).not_to be_successfully_executed
  end

  if negated
    expect(last_command_stopped).not_to have_output an_output_string_including(expected)
  else
    expect(last_command_stopped).to have_output an_output_string_including(expected)
  end
end

Then(/^it should( not)? (pass|fail) with:$/) do |negated, pass_fail, expected|
  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
  else
    expect(last_command_stopped).not_to be_successfully_executed
  end

  if negated
    expect(last_command_stopped).not_to have_output an_output_string_including(expected)
  else
    expect(last_command_stopped).to have_output an_output_string_including(expected)
  end
end

Then(/^it should( not)? (pass|fail) with exactly:$/) do |negated, pass_fail, expected|
  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
  else
    expect(last_command_stopped).not_to be_successfully_executed
  end

  if negated
    expect(last_command_stopped).not_to have_output an_output_string_eq(expected)
  else
    expect(last_command_stopped).to have_output an_output_string_being_eq(expected)
  end
end

Then(/^it should( not)? (pass|fail) (?:with regexp?|matching):$/) do |negated, pass_fail, expected|
  if pass_fail == 'pass'
    expect(last_command_stopped).to be_successfully_executed
  else
    expect(last_command_stopped).not_to be_successfully_executed
  end

  if negated
    expect(last_command_stopped).not_to have_output an_output_string_matching(expected)
  else
    expect(last_command_stopped).to have_output an_output_string_matching(expected)
  end
end

Then(/^(?:the )?(output|stderr|stdout) should not contain anything$/) do |channel|
  matcher = case channel.to_sym
            when :output
              :have_output
            when :stderr
              :have_output_on_stderr
            when :stdout
              :have_output_on_stdout
            else
              fail ArgumentError, %(Invalid channel "#{channel}" chosen. Only "output", "stdout" and "stderr" are supported.)
            end

  expect(all_commands).to include_an_object send(matcher, be_nil.or(be_empty))
end

Then(/^(?:the )?(output|stdout|stderr) should( not)? contain all of these lines:$/) do |channel, negated, table|
  table.raw.flatten.each do |expected|
    matcher = case channel.to_sym
              when :output
                :have_output
              when :stderr
                :have_output_on_stderr
              when :stdout
                :have_output_on_stdout
              else
                fail ArgumentError, %(Invalid channel "#{channel}" chosen. Only "output", "stdout" and "stderr" are supported.)
              end

    if negated
      expect(all_commands).not_to include_an_object have_output an_output_string_including(expected)
    else
      expect(all_commands).to include_an_object have_output an_output_string_including(expected)
    end
  end
end

Given(/the default aruba timeout is (\d+) seconds/) do |seconds|
  # rubocop:disable Metrics/LineLength
  Aruba.platform.deprecated(%{The /^the default aruba timeout is (\d+) seconds/ step definition is deprecated. Please use /^the default aruba exit timeout is (\d+) seconds/ step definition is deprecated.})
  # rubocop:enable Metrics/LineLength

  aruba.config.exit_timeout = seconds.to_i
end

Given(/The default aruba timeout is (\d+) seconds/) do |seconds|
  # rubocop:disable Metrics/LineLength
  Aruba.platform.deprecated(%{The /^The default aruba timeout is (\d+) seconds/ step definition is deprecated. Please use /^the default aruba exit timeout is (\d+) seconds/ step definition is deprecated.})
  # rubocop:enable Metrics/LineLength

  aruba.config.exit_timeout = seconds.to_i
end

Given(/^the (?:default )?aruba io wait timeout is (\d+) seconds?$/) do |seconds|
  aruba.config.io_wait_timeout = seconds.to_i
end

Given(/^the (?:default )?aruba exit timeout is (\d+) seconds?$/) do |seconds|
  aruba.config.exit_timeout = seconds.to_i
end

Given(/^the (?:default )?aruba stop signal is "([^"]*)"$/) do |signal|
  aruba.config.stop_signal = signal
end

Given(/^I wait (\d+) seconds? for (?:a|the) command to start up$/) do |seconds|
  aruba.config.startup_wait_time = seconds.to_i
end

When(/^I send the signal "([^"]*)" to the command (?:"([^"]*)"|(?:started last))$/) do |signal, command|
  if command
    cmd = all_commands.find { |c| c.commandline == command }
    fail ArgumentError, %(No command "#{command}" found) if cmd.nil?

    cmd.send_signal signal
  else
    last_command_started.send_signal signal
  end
end

Given(/^I look for executables in "(.*)" within the current directory$/) do |directory|
  prepend_environment_variable 'PATH', expand_path(directory) + File::PATH_SEPARATOR
end
