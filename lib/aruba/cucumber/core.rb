if Aruba::VERSION >= '1.0.0'
  Aruba.configure do |config|
    config.working_directory = 'tmp/cucumber'
  end
end

Given(/the default aruba timeout is (\d+) seconds/) do |seconds|
  aruba.config.exit_timeout = seconds.to_i
end

Given(/The default aruba timeout is (\d+) seconds/) do |seconds|
  warn(%{\e[35m    The  /^The default aruba timeout is (\d+) seconds/ step definition is deprecated. Please use the one with `the` and not `The` at the beginning.\e[0m})
  aruba.config.exit_timeout = seconds.to_i
end
