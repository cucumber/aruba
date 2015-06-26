# ideas taken from: http://blog.headius.com/2010/03/jruby-startup-time-tips.html
Aruba.configure do |config|
  config.before :cmd do
    next unless RUBY_PLATFORM == 'java'

    # disable JIT since these processes are so short lived
    set_env('JRUBY_OPTS', "-X-C #{ENV['JRUBY_OPTS']}")

    # force jRuby to use client JVM for faster startup times
    set_env('JAVA_OPTS', "-d32 #{ENV['JAVA_OPTS']}") if RbConfig::CONFIG['host_os'] =~ /solaris|sunos/i
  end
end
