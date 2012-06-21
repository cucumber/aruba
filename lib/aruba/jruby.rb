require 'rbconfig'
Aruba.configure do |config|
  config.before_cmd do
    # ideas taken from: http://blog.headius.com/2010/03/jruby-startup-time-tips.html
    set_env('JRUBY_OPTS', '-X-C') # disable JIT since these processes are so short lived
    # force jRuby to use client JVM for faster startup times. Not all systems support this.
    set_env('JAVA_OPTS', '-d32')  if RbConfig::CONFIG['host_os'] =~ /solaris|sunos/i
  end
end
