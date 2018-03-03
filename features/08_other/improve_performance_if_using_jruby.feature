Feature: Support for JRuby

  Improve startup time by disabling JIT and forcing client JVM mode.  This can
  be accomplished by adding

  ```ruby
  require 'aruba/config/jruby'
  ```

  *Note* - no conflict resolution on the JAVA/JRuby environment options is
  done; only merging. For more complex settings please manually set the
  environment variables in the hook or externally.

  Refer to http://blog.headius.com/2010/03/jruby-startup-time-tips.html for other tips on startup time.

  Background:
    Given I use a fixture named "cli-app"

  @requires-ruby-platform-java
  Scenario:
    Given a file named "spec/jruby_env_spec.rb" with:
      """
      require 'spec_helper'
      require 'aruba/config/jruby'

      RSpec.describe 'running commands with before :command hook', :type => :aruba do
        it 'sets up for efficient JRuby startup' do
          with_environment 'JRUBY_OPTS' => '-d' do
            run_command_and_stop('env')

            expect(last_command_started.output).to include 'JRUBY_OPTS=--dev -X-C -d'
          end
        end
      end
      """
    When I run `rspec`
    Then the specs should all pass
