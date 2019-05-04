require 'cucumber/platform'

Before '@requires-python' do |scenario|
  next unless Aruba.platform.which('python').nil?

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-java' do |scenario|
  next unless Aruba.platform.which('javac').nil?

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-perl' do |scenario|
  next unless Aruba.platform.which('perl').nil?

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-ruby' do |scenario|
  next unless Aruba.platform.which('ruby').nil?

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-posix-standard-tools' do |scenario|
  next unless Aruba.platform.which('printf').nil?

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-ruby-version-193' do |scenario|
  next if RUBY_VERSION >= '1.9.3'

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-ruby-version-19' do |scenario|
  next if RUBY_VERSION >= '1.9'

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-ruby-version-2' do |scenario|
  next if RUBY_VERSION >= '2'

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-aruba-version-1' do |scenario|
  next if Aruba::VERSION > '1'

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-ruby-platform-java' do |scenario|
  # leave if java
  next if RUBY_PLATFORM.include? 'java'

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-ruby-platform-mri' do |scenario|
  # leave if not java
  next unless RUBY_PLATFORM.include? 'java'

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@unsupported-on-platform-windows' do |scenario|
  # leave if not windows
  next unless FFI::Platform.windows?

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@unsupported-on-platform-unix' do |scenario|
  # leave if not windows
  next unless FFI::Platform.unix?

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@unsupported-on-platform-mac' do |scenario|
  # leave if not windows
  next unless FFI::Platform.mac?

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end
