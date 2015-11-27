Feature: Support for JRuby

  Improve startup time by disabling JIT and forcing client JVM mode.  This can
  be accomplished by adding

  ```ruby
  require 'aruba/jruby'
  ```

  *Note* - no conflict resolution on the JAVA/JRuby environment options is
  done; only merging. For more complex settings please manually set the
  environment variables in the hook or externally.

  Refer to http://blog.headius.com/2010/03/jruby-startup-time-tips.html for other tips on startup time.
