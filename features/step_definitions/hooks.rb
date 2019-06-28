require 'cucumber/platform'

Before '@requires-python' do |scenario|
  next unless Aruba.platform.which('python').nil?

  skip_this_scenario
end

Before '@requires-java' do |scenario|
  next unless Aruba.platform.which('javac').nil?

  skip_this_scenario
end

Before '@requires-perl' do |scenario|
  next unless Aruba.platform.which('perl').nil?

  skip_this_scenario
end

Before '@requires-ruby' do |scenario|
  next unless Aruba.platform.which('ruby').nil?

  skip_this_scenario
end

Before '@requires-posix-standard-tools' do |scenario|
  next unless Aruba.platform.which('printf').nil?

  skip_this_scenario
end

Before '@requires-ruby-platform-java' do |scenario|
  # leave if java
  next if RUBY_PLATFORM.include? 'java'

  skip_this_scenario
end

Before '@unsupported-on-platform-java' do |scenario|
  # leave if not java
  next unless RUBY_PLATFORM.include? 'java'

  skip_this_scenario
end

Before '@unsupported-on-platform-windows' do |scenario|
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

Before '@unsupported-on-platform-unix' do |scenario|
  # leave if not windows
  next unless FFI::Platform.unix?

  skip_this_scenario
end

Before '@unsupported-on-platform-mac' do |scenario|
  # leave if not windows
  next unless FFI::Platform.mac?

  skip_this_scenario
end
