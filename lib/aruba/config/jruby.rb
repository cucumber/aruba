require 'rbconfig'

# ideas taken from: http://blog.headius.com/2010/03/jruby-startup-time-tips.html
Aruba.configure do |config|
  config.before :command do
    next unless RUBY_PLATFORM == 'java'

    jruby_opts = aruba.environment['JRUBY_OPTS'] || ''

    # disable JIT since these processes are so short lived
    jruby_opts = "-X-C #{jruby_opts}" unless jruby_opts.include? '-X-C'

    # Faster startup for jruby
    jruby_opts = "--dev #{jruby_opts}" unless jruby_opts.include? '--dev'

    set_environment_variable('JRUBY_OPTS', jruby_opts)

    if RbConfig::CONFIG['host_os'] =~ /solaris|sunos/i
      java_opts = aruba.environment['JAVA_OPTS'] || ''

      # force jRuby to use client JVM for faster startup times
      set_environment_variable('JAVA_OPTS', "-d32 #{java_opts}") unless java_opts.include?('-d32')
    end
  end
end
