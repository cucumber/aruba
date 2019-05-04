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

Before '@requires-ruby-platform-java' do |scenario|
  # leave if java
  next if RUBY_PLATFORM.include? 'java'

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@unsupported-on-platform-java' do |scenario|
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

Before '@requires-readline' do
  begin
    require 'readline'
  rescue LoadError
    if Cucumber::VERSION < '2'
      skip_invoke!
    else
      skip_this_scenario
    end
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
