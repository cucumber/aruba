require 'cucumber/platform'

Before '@requires-ruby-version-193' do
  next if RUBY_VERSION >= '1.9.3'

  if Cucumber::VERSION < '2'
    skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-ruby-version-19' do
  next if RUBY_VERSION >= '1.9'

  if Cucumber::VERSION < '2'
    skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-ruby-version-2' do
  next if RUBY_VERSION >= '2'

  if Cucumber::VERSION < '2'
    skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-aruba-version-1' do
  next if Aruba::VERSION > '1'

  if Cucumber::VERSION < '2'
    skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-ruby-platform-java' do
  # leave if java
  next if RUBY_PLATFORM.include? 'java'

  if Cucumber::VERSION < '2'
    skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-ruby-platform-mri' do
  # leave if not java
  next unless RUBY_PLATFORM.include? 'java'

  if Cucumber::VERSION < '2'
    skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@unsupported-on-platform-windows' do
  # leave if not windows
  next unless FFI::Platform.windows?

  if Cucumber::VERSION < '2'
    skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@unsupported-on-platform-unix' do
  # leave if not windows
  next unless FFI::Platform.unix?

  if Cucumber::VERSION < '2'
    skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@unsupported-on-platform-mac' do
  # leave if not windows
  next unless FFI::Platform.mac?

  if Cucumber::VERSION < '2'
    skip_invoke!
  else
    skip_this_scenario
  end
end
