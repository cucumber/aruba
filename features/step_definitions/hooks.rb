require 'cucumber/platform'

Before '@requires-python' do |_scenario|
  next unless Aruba.platform.which('python').nil?

  skip_this_scenario
end

Before '@requires-zsh' do |scenario|
  next unless Aruba.platform.which('zsh').nil?

  if Cucumber::VERSION < '2'
    scenario.skip_invoke!
  else
    skip_this_scenario
  end
end

Before '@requires-java' do |_scenario|
  next unless Aruba.platform.which('javac').nil?

  skip_this_scenario
end

Before '@requires-perl' do |_scenario|
  next unless Aruba.platform.which('perl').nil?

  skip_this_scenario
end

Before '@requires-ruby' do |_scenario|
  next unless Aruba.platform.which('ruby').nil?

  skip_this_scenario
end

Before '@requires-posix-standard-tools' do |_scenario|
  next unless Aruba.platform.which('printf').nil?

  skip_this_scenario
end

Before '@requires-ruby-platform-java' do |_scenario|
  # leave if java
  next if RUBY_PLATFORM.include? 'java'

  skip_this_scenario
end

Before '@unsupported-on-platform-java' do |_scenario|
  # leave if not java
  next unless RUBY_PLATFORM.include? 'java'

  skip_this_scenario
end

Before '@unsupported-on-platform-windows' do |_scenario|
  # leave if not windows
  next unless FFI::Platform.windows?

  skip_this_scenario
end

Before '@requires-readline' do
  begin
    require 'readline'
  rescue LoadError
    skip_this_scenario
  end
end

Before '@unsupported-on-platform-unix' do |_scenario|
  # leave if not windows
  next unless FFI::Platform.unix?

  skip_this_scenario
end

Before '@unsupported-on-platform-mac' do |_scenario|
  # leave if not windows
  next unless FFI::Platform.mac?

  skip_this_scenario
end
