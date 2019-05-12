require 'rbconfig'

# ideas taken from: http://blog.headius.com/2010/03/jruby-startup-time-tips.html
Aruba.configure do |config|
  config.before :command do |command|
    next unless RUBY_PLATFORM == 'java'

    env = command.environment

    jruby_opts = env['JRUBY_OPTS'] || ''

    # disable JIT since these processes are so short lived
    jruby_opts = "-X-C #{jruby_opts}" unless jruby_opts.include? '-X-C'

    # Faster startup for jruby
    jruby_opts = "--dev #{jruby_opts}" unless jruby_opts.include? '--dev'

    env['JRUBY_OPTS'] = jruby_opts

    if RbConfig::CONFIG['host_os'] =~ /solaris|sunos/i
      java_opts = env['JAVA_OPTS'] || ''

      # force jRuby to use client JVM for faster startup times
      env['JAVA_OPTS'] = "-d32 #{java_opts}" unless java_opts.include?('-d32')
    end
  end
end
