if Aruba::VERSION >= '1.0.0'
  Aruba.configure do |config|
    config.working_directory = 'tmp/cucumber'
  end
end

Given(/the default aruba timeout is (\d+) seconds/) do |seconds|
  # rubocop:disable Metrics/LineLength
  Aruba::Platform.deprecated(%{The /^the default aruba timeout is (\d+) seconds/ step definition is deprecated. Please use /^the default aruba exit timeout is (\d+) seconds/ step definition is deprecated.})
  # rubocop:enable Metrics/LineLength

  aruba.config.exit_timeout = seconds.to_i
end

Given(/The default aruba timeout is (\d+) seconds/) do |seconds|
  # rubocop:disable Metrics/LineLength
  Aruba::Platform.deprecated(%{The /^The default aruba timeout is (\d+) seconds/ step definition is deprecated. Please use /^the default aruba exit timeout is (\d+) seconds/ step definition is deprecated.})
  # rubocop:enable Metrics/LineLength

  aruba.config.exit_timeout = seconds.to_i
end

Given(/the default aruba io wait timeout is (\d+) seconds/) do |seconds|
  aruba.config.io_wait_timeout = seconds.to_i
end

Given(/the default aruba exit timeout is (\d+) seconds/) do |seconds|
  aruba.config.exit_timeout = seconds.to_i
end
