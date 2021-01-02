require 'cucumber/platform'

Before '@requires-python' do
  next unless Aruba.platform.which('python').nil?

  skip_this_scenario
end

Before '@requires-zsh' do
  next unless Aruba.platform.which('zsh').nil?

  skip_this_scenario
end

Before '@requires-java' do
  next unless Aruba.platform.which('javac').nil?

  skip_this_scenario
end

Before '@requires-perl' do
  next unless Aruba.platform.which('perl').nil?

  skip_this_scenario
end

Before '@requires-ruby' do
  next unless Aruba.platform.which('ruby').nil?

  skip_this_scenario
end

Before '@requires-posix-standard-tools' do
  next unless Aruba.platform.which('printf').nil?

  skip_this_scenario
end

Before '@requires-ruby-platform-java' do
  skip_this_scenario unless Cucumber::JRUBY
end

Before '@unsupported-on-platform-java' do
  skip_this_scenario if Cucumber::JRUBY
end

Before '@unsupported-on-platform-windows' do
  skip_this_scenario if Cucumber::WINDOWS
end

Before '@requires-readline' do
  begin
    require 'readline'
  rescue LoadError
    skip_this_scenario
  end
end

Before '@unsupported-on-platform-unix' do
  skip_this_scenario unless Cucumber::WINDOWS
end

Before '@unsupported-on-platform-mac' do
  skip_this_scenario if Cucumber::OS_X
end
