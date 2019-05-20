Before('@announce-cmd') do
  Aruba.platform.deprecated 'The use of "@announce-cmd"-hook is deprecated. Please use "@announce-command"'

  aruba.announcer.activate :command
end

Before('@announce-dir') do
  Aruba.platform.deprecated 'The use of "@announce-dir"-hook is deprecated. Please use "@announce-directory"'

  aruba.announcer.activate :directory
end

Before('@announce-env') do
  Aruba.platform.deprecated 'The use of "@announce-env"-hook is deprecated. Please use "@announce-changed-environment"'

  aruba.announcer.activate :environment
end

Before('@announce-environment') do
  Aruba.platform.deprecated '@announce-environment is deprecated. Use @announce-changed-environment instead'

  aruba.announcer.activate :changed_environment
end

Before('@announce-modified-environment') do
  Aruba.platform.deprecated '@announce-modified-environment is deprecated. Use @announce-changed-environment instead'

  aruba.announcer.activate :changed_environment
end

Before('@ansi') do
  # rubocop:disable Metrics/LineLength
  Aruba::Platform.deprecated('The use of "@ansi" is deprecated. Use "@keep-ansi-escape-sequences" instead. But be aware, that this hook uses the aruba configuration and not an instance variable')
  # rubocop:enable Metrics/LineLength

  aruba.config.remove_ansi_escape_sequences = false
end


Before '@mocked_home_directory' do
  Aruba.platform.deprecated('The use of "@mocked_home_directory" is deprecated. Use "@mocked-home-directory" instead')

  set_environment_variable 'HOME', expand_path('.')
end

When(/^I run "(.*)"$/)do |cmd|
  warn(%{\e[35m    The /^I run "(.*)"$/ step definition is deprecated. Please use the `backticks` version\e[0m})

  cmd = sanitize_text(cmd)
  run_command_and_stop(cmd, false)
end

When(/^I successfully run "(.*)"$/)do |cmd|
  warn(%{\e[35m    The  /^I successfully run "(.*)"$/ step definition is deprecated. Please use the `backticks` version\e[0m})

  cmd = sanitize_text(cmd)
  run_command_and_stop(cmd)
end

When(/^I run "([^"]*)" interactively$/) do |cmd|
  Aruba.platform.deprecated(%{\e[35m    The /^I run "([^"]*)" interactively$/ step definition is deprecated. Please use the `backticks` version\e[0m})

  step %(I run `#{cmd}` interactively)
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

Then(/^the mode of filesystem object "([^"]*)" should (not )?match "([^"]*)"$/) do |file, negated, permissions|
  # rubocop:disable Metrics/LineLength
  Aruba.platform.deprecated('The use of step "the mode of filesystem object "([^"]*)" should (not )?match "([^"]*)" is deprecated. Use "^the (?:file|directory)(?: named)? "([^"]*)" should have permissions "([^"]*)"$" instead')
  # rubocop:enable Metrics/LineLength

  if negated
    expect(file).not_to have_permissions(permissions)
  else
    expect(file).to have_permissions(permissions)
  end
end

