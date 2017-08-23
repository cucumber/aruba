Please see [CONTRIBUTING.md](https://github.com/cucumber/cucumber/blob/master/CONTRIBUTING.md) on how to contribute to Cucumber.

## [v1.0.0-alpha.2](https://github.com/cucumber/aruba/compare/v1.0.0.alpha.2...v1.0.0.alpha.3)

**Not released yet**

* Remove development gems for unsupported Rubinius platform
* Improve documentation for users and developers ([#454](https://github.com/cucumber/aruba/issues/454), [#456](https://github.com/cucumber/aruba/issues/456), [#457](https://github.com/cucumber/aruba/issues/457), [#460](https://github.com/cucumber/aruba/issues/460), [#459](https://github.com/cucumber/aruba/issues/459))
* Fix UTF-8 issues with jRuby ([#464](https://github.com/cucumber/aruba/issues/464), [stamhankar999](https://github.com/stamhankar999))
* Fix bugs in Travis build ([#462](https://github.com/cucumber/aruba/issues/462))

## [v1.0.0-alpha.2](https://github.com/cucumber/aruba/compare/v1.0.0.alpha.1...v1.0.0.alpha.2)

* Update examples for usage in README
* Fix environment manipulation ([#442](https://github.com/cucumber/aruba/issues/442))
* Update supported ruby versions in .travis.yml ([#449](https://github.com/cucumber/aruba/issues/449))
* Use license_finder version which is usable for rubies `< 2.3` ([#451](https://github.com/cucumber/aruba/issues/451))
* Wrap test runners in `bundle exec` ([#447](https://github.com/cucumber/aruba/issues/447))
* Fix wording in README ([#445](https://github.com/cucumber/aruba/issues/445))
* Restructure README and upload feature files to cucumber.pro ([#444](https://github.com/cucumber/aruba/issues/444))

## [v1.0.0-alpha.1](https://github.com/cucumber/aruba/compare/v0.14.1...v1.0.0.alpha.1)

* Use new proposed structure for gems by bundler ([#439](https://github.com/cucumber/aruba/issues/439))
* Rename methods which run commands ([#438](https://github.com/cucumber/aruba/issues/438))
* Fix dependency error for install ([#427](https://github.com/cucumber/aruba/issues/427))
* Actually fail the build if rake test fails ([#433](https://github.com/cucumber/aruba/issues/433))
* Improve frozen-string-literals compatibility. ([#436](https://github.com/cucumber/aruba/issues/436))
* Fix running commands on Windows ([#387](https://github.com/cucumber/aruba/issues/387))
* Fix running commands on Windows ([#387](https://github.com/cucumber/aruba/issues/387))
* Set permissions to values which are supported on Windows ([#398](https://github.com/cucumber/aruba/issues/398), [#388](https://github.com/cucumber/aruba/issues/388))
* Remove Aruba::Reporting ([#389](https://github.com/cucumber/aruba/issues/389))
* Rename bin/cli to bin/aruba-test-cli to prevent name conflict ([#390](https://github.com/cucumber/aruba/issues/390))
* Drop support for `ruby < 1.9.3` and rubinius ([#385](https://github.com/cucumber/aruba/issues/385))
* Fixed wrong number of arguments in `Aruba::Platforms::WindowsEnvironmentVariables#delete` ([#349](https://github.com/cucumber/aruba/issues/349), [#358](https://github.com/cucumber/aruba/issues/358), [e2](https://github.com/e2))
* Fixed colors in `script/bootstrap` ( [#352](https://github.com/cucumber/aruba/issues/352), [e2](https://github.com/e2))
* Fixed use of removed `Utils`-module ([#347](https://github.com/cucumber/aruba/issues/347), [e2](https://github.com/e2))
* Fixed exception handler in BasicProcess ([#357](https://github.com/cucumber/aruba/issues/357), [e2](https://github.com/e2))
* Fixed step to check for existing of files ([#375](https://github.com/cucumber/aruba/issues/375), [rubbish](https://github.com/rubbish))
* Fixed unset instance variable (#[#372](https://github.com/cucumber/aruba/issues/372), [e2](https://github.com/e2))
* Added vision and hints to project README ([#366](https://github.com/cucumber/aruba/issues/366))
* Fixed setting environment variables on Windows ([#358](https://github.com/cucumber/aruba/issues/358), [e2](https://github.com/e2))
* Fixed the logic to determine disk usage ([#359](https://github.com/cucumber/aruba/issues/359), [e2](https://github.com/e2))
* Prefixed exception in `rescue`-call to make it fail with a proper error message ([#376](https://github.com/cucumber/aruba/issues/376))
* Run and build aruba in isolated environment via docker ([#353](https://github.com/cucumber/aruba/issues/353) [e2](https://github.com/e2), [#382](https://github.com/cucumber/aruba/issues/382))
* Run container with docker-compose without making docker-compose a required dependency. Rake tasks read in the docker-compose.yml instead ([#382](https://github.com/cucumber/aruba/issues/382))
* Document developer rake tasks via cucumber features ([#382](https://github.com/cucumber/aruba/issues/382))
* Add more hints to CONTRIBUTING.md ([#382](https://github.com/cucumber/aruba/issues/382))
* Add TESTING.md (WIP) ([#382](https://github.com/cucumber/aruba/issues/382), [e2](https://github.com/e2))
* Cleanup rake tasks via separate namespaces ([#382](https://github.com/cucumber/aruba/issues/382))
* Some more minor fixes ([#382](https://github.com/cucumber/aruba/issues/382))
* Don't run feature test if executable required for test is not installed (python, bash, zsh, javac, ...) ([#382](https://github.com/cucumber/aruba/issues/382))
* Support for rubies older than 1.9.3 is discontinued - e.g 1.8.7 and 1.9.2
* aruba requires "cucumber 2" for the feature steps. The rest of aruba should
  be usable by whatever testing framework you are using.
* Overwriting methods for configuration is discontinued. You need to use
  `aruba.config.<variable>` or `Aruba.configure { |config| config.<variable>`
  instead.
* "aruba/reporting" will be removed. Please use `@debug`-tag + `byebug`,
  `debugger`, `pry` to troubleshoot your feature tests.
* Set environment variables will have only effect on `#run` and the like +
  `#with_environment { }`.
* The process environment will be fully resetted between tests. Sharing state
  via ENV['VAR'] = 'shared state' between tests will not be possible anymore.
  Please make that obvious by using explicit steps or use the aruba API for
  that.
* There will be a major cleanup for command execution. There will be only
  `run` and `run_simple` left. `run_interactive` is replaced by `run`.
* Setting the root directory of aruba via method overwrite or configuration -
  this should be your project root directory where the test suite is run.
* The direct use of "InProcess", "DebugProcess" and "SpawnProcess" is not
  supported anymore. You need to use "Command" instead. But be careful, it has
  a different API.
* HOME can be configured via `Aruba.configure {}` and defaults to
  `File.join(aruba.config.root_directory, aruba.config.working_directory?)`
  if `aruba/cucumber` or `aruba/rspec` is used.
* Use different working directories based on test suite - RSpec, Cucumber.
  It's `tmp/rspec` and `tmp/cucumber` now to make sure they do not overwrite
  the test results from each other.
* The use of `@interactive` is discontinued. You need to use
  `#last_command_started`-method to get access to the interactively started
  command.
* If multiple commands have been started, each output has to be check
  separately

  ```cucumber
  Scenario: Detect stdout from all processes
    When I run `printf "hello world!\n"`
    And I run `cat` interactively
    And I type "hola"
    And I type ""
    Then the stdout should contain:
      """
      hello world!
      """
    And the stdout should contain:
      """
      hola
      """
    And the stderr should not contain anything
  ```

## [v0.14.1](https://github.com/cucumber/aruba/compare/v0.14.0...v0.14.1)

* Fixed bug in framework step

## [v0.14.0](https://github.com/cucumber/aruba/compare/v0.13.0...v0.14.0)

* Add `<project_root>/exe` to search path for commands: This is the new default if you setup a
  project with bundler.
* Add some more steps to modify environment

## [v0.13.0](https://github.com/cucumber/aruba/compare/v0.12.0...v0.13.0)

* Add two new hooks for rspec and cucumber to make troubleshooting feature
  files easier ([#338](https://github.com/cucumber/aruba/issues/338)):
  * command_content: Outputs command content - helpful for scripts
  * command_filesystem_status: Outputs information like group, owner, mode,
    atime, mtime
* Add generator to create ad hoc script file ([#323](https://github.com/cucumber/aruba/issues/323), [AdrieanKhisbe](https://github.com/AdrieanKhisbe))
* Colored announcer output similar to the color of `cucumber` tags: cyan
* Fixed bug in announcer. It announces infomation several times due to
  duplicate announce-calls.
* Refactorings to internal `#simple_table`-method (internal)
* Refactored Announcer, now it supports blocks for announce as well (internal)
* Fix circular require warnings ([#339](https://github.com/cucumber/aruba/issues/339))
* Fix use of old instances variable "@io_wait" ([#341](https://github.com/cucumber/aruba/issues/341)). Now the
  default value for io_wait_timeout can be set correctly.
* Make it possible to announce information on command error, using a new option 
  called `activate_announcer_on_command_failure` ([#335](https://github.com/cucumber/aruba/issues/335), [njam](https://github.com/njam))
* Re-integrate `event-bus`-library into `aruba`-core ([#342](https://github.com/cucumber/aruba/issues/342))

## [v0.12.0](https://github.com/cucumber/aruba/compare/v0.11.2...v0.12.0)

* Add matcher to check if a command can be found in PATH ([#336](https://github.com/cucumber/aruba/issues/336))
* Fixed issue with environment variables set by external libraries ([#321](https://github.com/cucumber/aruba/issues/321), [#320](https://github.com/cucumber/aruba/issues/320))

## [v0.11.2](https://github.com/cucumber/aruba/compare/v0.11.1...v0.11.2)

* Fixed problem with positional arguments in `#run_simple()` ([#322](https://github.com/cucumber/aruba/issues/322))


## [v0.11.1](https://github.com/cucumber/aruba/compare/v0.11.0...v0.11.1)

* Use fixed version of event-bus
* Refactored and improved documentation (feature tests) in [#309](https://github.com/cucumber/aruba/issues/309)

## [v0.11.0](https://github.com/cucumber/aruba/compare/v0.11.0.pre4...v0.11.0)

* Accidently pushed to rubygems.org - yanked it afterwards

## [v0.11.0.pre4](https://github.com/cucumber/aruba/compare/v0.11.0.pre3...v0.11.0.pre4)

* Fixed syntax for Hash on ruby 1.8.7
* Reorder rubies in .travis.yml

## [v0.11.0.pre3](https://github.com/cucumber/aruba/compare/v0.11.0.pre2...v0.11.0.pre3)

* Fixed syntax for proc on ruby 1.8.7

## [v0.11.0.pre2](https://github.com/cucumber/aruba/compare/v0.11.0.pre...v0.11.0.pre2)

* Integrate `EventBus` to decouple announcers from starting, stopping commands
  etc. This uses nearly the same implementation like `cucumber`. ([#309](https://github.com/cucumber/aruba/issues/309))
* Starting/Stopping a command directly (`command.start`, `command.stop`) is now
  reported to the command monitor and `last_command_stopped` is updated
  correctly
* Added `#restart` to `Command` to make it possible to restart a command
* Added check to prevent a command which has already been started, to be
  started again. Otherwise you've got hidden commands which are not stopped
  after a cucumber/rspec/minitest run.
* Adding alot of documentation to `aruba`
* Refactored `#run`: Now it wants you to pass a `Hash` containing the options.
  The old syntax is still supported, but is deprecated.
* Added `#find_command` as experimental feature. It searches the started
  commands from last to first.
* Added `be_an_executable` matcher


## [v0.11.0.pre](https://github.com/cucumber/aruba/compare/v0.10.2...v0.11.0.pre)

* Set stop signal which should be used to stop a process after a timeout or
  used to terminate a process. This can be used to stop processes running
  docker + "systemd". If you send a systemd-enable container SIGINT it will be
  stopped.
* Added a configurable amount of time after a command was started -
  startup_wait_time. Otherwise you get problems when a process takes to long to
  startup when you run in background and want to sent it a signal.
* Replace `<variable>` in commandline, e.g. `<pid-last-command-started>`
  [experimental]
* Added announce formatter for time spans, e.g. `startup_wait_time`
* All `*Process`-classes e.g. `BasicProcess`, `SpawnProcess` etc. are marked as
  private. Users should use `#run('cmd')` and don't use the classes directly.
* `rvm`-methods are deprecated. They too ruby specific.


## [v0.10.2](https://github.com/cucumber/aruba/compare/v0.10.1...v0.10.2)

* Fixed problem in regex after merge of step definitions


## [v0.10.1](https://github.com/cucumber/aruba/compare/v0.10.0...v0.10.1)

* Merged remove steps for file and directory from 4 into 2 step definitions


## [v0.10.0](https://github.com/cucumber/aruba/compare/v0.10.0.pre2...v0.10.0)

* Fix '"#exit_timeout" is deprecated' error ([#314](https://github.com/cucumber/aruba/issues/314))

## [v0.10.0.pre2](https://github.com/cucumber/aruba/compare/v0.10.0.pre...v0.10.0.pre2)

* Take over code from `RSpec::Support::ObjectFormatter` since `rspec-support`
  is not intended for public use.

## [v0.10.0.pre](https://github.com/cucumber/aruba/compare/v0.9.0...v0.10.0)

* Add some new steps to make writing documentation easier using "cucumber",
  "rspec", "minitest" together with "aruba" - see [Feature](features/getting_started/supported_testing_frameworks.feature)
  for some examples
* Write output of commands directly to disk if SpawnProcess is used (see https://github.com/cucumber/aruba/commit/85d74fcca4fff4e753776925d8b003cddaa8041d)
* Refactored API of cucumber steps to reduce the need for more methods and make
  it easier for users to write their own steps ([#306](https://github.com/cucumber/aruba/issues/306))
* Added `aruba init` to the cli command to setup environment for aruba (issue
  [#308](https://github.com/cucumber/aruba/issues/308))
* Added new method `delete_environment_variable` to remove environment variable
* Added work around because of method name conflict between Capybara and RSpec
  (https://github.com/cucumber/aruba/commit/1939c4049d5195ffdd967485f50119bdd86e98a0)


## [v0.9.0](https://github.com/cucumber/aruba/compare/v0.9.0.pre2...v0.9.0)

* Fix feature test
* Fix ordering in console
* Fix bug in console handling SIGINT
* Deprecated Aruba/Reporting before we remove it

## [v0.9.0.pre2](https://github.com/cucumber/aruba/compare/v0.9.0.pre...v0.9.0.pre2)

* Redefine #to_s and #inspect for BasicProcess to reduce the sheer amount of
  information, if a command produces a lot of output
* Added new matcher `#all_objects` to check if an object is included + a error message for
  failures which is similar to the `#all`-matcher of `RSpec`
* Add `have_output`-, `have_output_on_stderr`, `have_output_on_stdout`-matchers
* Replace all `assert_*` and `check_*`-methods through expectations
* Add hook `@announce-output` to output both, stderr and stdout
* Add a lot of documentation ([#260](https://github.com/cucumber/aruba/issues/260))
* Replace `#last_command` through `#last_command_started` and
  `#last_command_stopped` to make it more explicit
* Improve syntax highlighting in cucumber feature tests by adding programming
  language to `"""`-blocks
* Rename tags `@ignore-*` to `@unsupported-on-*`
* Introduce our own `BaseMatcher`-class to remove the dependency to `RSpec`'s
  private matcher APIs
* Now we make the process started via `SpawnProcess` the leader of the group to
  kill all sub-processes more reliably


## [v0.9.0.pre](https://github.com/cucumber/aruba/compare/v0.8.1...v0.9.0.pre)

* Improve documentation for filesystem api and move it to feature tests
* Add logger to aruba. Its output can be captured by rspec.
* Fix incorrect deprecation message for check_file_presence ([#292](https://github.com/cucumber/aruba/issues/292))
* Fix for Gemfile excludes windows for many gems ([#282](https://github.com/cucumber/aruba/issues/282))
* Make feature tests compatible with ruby 1.9.2
* Gather disk usage for file(s) ([#294](https://github.com/cucumber/aruba/issues/294))
* Replace keep_ansi-config option by remove_ansi_escape_sequences-option
* Split up `#unescape` into `#extract_text` and `#unescape_text`
* Use `UnixPlatform` and `WindowsPlatform` to make code for different platforms maintainable
* Work around `ENV`-bug in `Jruby` buy using `#dup` on `ENV.to_h` (jruby/jruby issue [#316](https://github.com/jruby/jruby/issues/316))
* Speed up test on `JRuby` by using `--dev`-flag
* Work around problems when copying files with `cp` on MRI-ruby 1.9.2
* Add cmd.exe /c for SpawnProcess on Windows ([#302](https://github.com/cucumber/aruba/issues/302))
* Split up `#which` for Windows and Unix/Linux ([#304](https://github.com/cucumber/aruba/issues/304))
* Add `aruba console`-command to play around with aruba ([#305](https://github.com/cucumber/aruba/issues/305))


## [v0.8.1](https://github.com/cucumber/aruba/compare/v0.8.0...v0.8.1)

* Fix problem if working directory of aruba does not exist ([#286](https://github.com/cucumber/aruba/issues/286))
* Re-Add removed method only_processes
* Fixed problem with last exit status
* Added appveyor to run tests of aruba on Windows ([#287](https://github.com/cucumber/aruba/issues/287))
* Make the home directory configurable and use Around/around-hook to apply it
* Add announcer to output the full environment before a command is run
* Use prepend_environment_variable to modify PATH for rspec integration
* Add VERSION-constant to aruba and use it for code which should be activated on >= 1.0.0

## [v0.8.0](https://github.com/cucumber/aruba/compare/v0.8.0.pre3...v0.8.0)

* Build with cucumber 1.3.x on ruby 1.8.7, with cucumber 2.x on all other platforms
* Fixed bugs in aruba's cucumber steps
* Disable use of `win32/file`
* Fixed but in `in_current_dir*` not returning the result of the block
* Fixed checks for file content
* Fixed selectors for DebugProcess and InProcess to support sub-classes as well


## [v0.8.0.pre3](https://github.com/cucumber/aruba/compare/v0.8.0.pre2...v0.8.0.pre3)

* Depend on cucumber 1.3.x for compatibility on ruby 1.8.7
* Change PWD and OLDPW when `cd('path') {}` is used within that block
* Make nesting of `cd` possible
* Make `run` inside `cd` possible
* Fixed some bugs
* Move `Aruba.proces = InProcess|SpawnProcess|DebugProcess` to `aruba.config`
* Deprecate direct use of `InProcess|SpawnProcess|DebugProcess`. Now `Command`
  needs to be used
* Add new configuration options `command_launcher` and `main_klass` for
  deprecation of old-style `Aruba.process = <class>`, `:spawn` is the default
  value for the `command_launcher`-option
* Added checks for version of `rspec-expectations` to support older `rspec`
  versions like `2.11`
* Now each `path/to/dir` pushed to `aruba.current_directory` is `pop`ed as whole
* Make testing of `aruba.current_directory` easier by supporting `end_with?` and `start_with?`

## [v0.8.0.pre2](https://github.com/cucumber/aruba/compare/v0.8.0...v0.8.0.pre2)

* Relax requirement on rspec-expectations (3.3 -> 2.11)

## [v0.8.0.pre](https://github.com/cucumber/aruba/compare/v0.7.4...v0.8.0.pre)

* Make aruba compatible with "ruby 1.8.7" and "ruby 1.9.3" again ([#279](https://github.com/cucumber/aruba/issues/279))
* Move more and more documentation to cucumber steps ([#268](https://github.com/cucumber/aruba/issues/268))
* Refactoring of test suits, now rspec tests run randomly
* Move Aruba constants to configuration class ([#271](https://github.com/cucumber/aruba/issues/271))
* Added runtime configuration via `aruba.config` which is reset for each test run
* Refactored hooks: now there are `after()` and `before()`-hooks, old
  before_cmd-hook is still working, but is deprecated, added new
  `after(:command)`-hook.
* Refactored jruby-startup helper
* Cleanup API by moving deprecated methods to separate class
* Cleanup Core API - reduced to `cd`, `expand_path`, `setup_aruba` and use expand_path wherever possible ([#253](https://github.com/cucumber/aruba/issues/253))
* Better isolation for environment variable manipulation - really helpful from 1.0.0 on
* Move configuration files like `jruby.rb` to `aruba/config/`-directory
* Change default exit timeout to 15 seconds to work around long running processes on travis
* Use of instance variables like @aruba_timeout_seconds or
  @aruba_io_wait_seconds are deprecated. Use `Aruba.configure do |config|
  config.exit_timeout = 10` etc. for this.

## [v0.7.4](https://github.com/cucumber/aruba/compare/v0.7.2...v0.7.4)
* Really Fixed post install message

## [v0.7.3](https://github.com/cucumber/aruba/compare/v0.7.2...v0.7.3)
* Fixed post install message

## [v0.7.2](https://github.com/cucumber/aruba/compare/v0.7.1...v0.7.2)
* Do not trigger Announcer API deprecation warning ([#277](https://github.com/cucumber/aruba/issues/277))

## [v0.7.1](https://github.com/cucumber/aruba/compare/v0.7.0...v0.7.1)
* Do not break if @interactive is used 

## [v0.7.0](https://github.com/cucumber/aruba/compare/v0.6.2...v0.7.0)
* Introducing root_directory ([#232](https://github.com/cucumber/aruba/issues/232))
* Introducing fixtures directory ([#224](https://github.com/cucumber/aruba/issues/224))
* Make sure a file/directory does not exist + Cleanup named file/directory steps ([#234](https://github.com/cucumber/aruba/issues/234))
* Make matcher have_permisions public and add documentation ([#239](https://github.com/cucumber/aruba/issues/239))
* Added matcher for file content ([#238](https://github.com/cucumber/aruba/issues/238))
* Add rspec integrator ([#244](https://github.com/cucumber/aruba/issues/244))
* Deprecate _file/_directory in method names ([#243](https://github.com/cucumber/aruba/issues/243))
* Improve development environment ([#240](https://github.com/cucumber/aruba/issues/240))
* Cleanup process management ([#257](https://github.com/cucumber/aruba/issues/257))
* Make path content available through matchers and api metchods ([#250](https://github.com/cucumber/aruba/issues/250))
* Refactor announcer to support user defined announce channels (fixes [#267](https://github.com/cucumber/aruba/issues/267))
* `InProcess` requires that the working directory is determined on runtime not no loadtime

## [v0.6.2](https://github.com/cucumber/aruba/compare/v0.6.1...v0.6.2)
* Fixed minor [#223](https://github.com/cucumber/aruba/issues/223))
* Added support for ruby 2.1.3 -- 2.1.5
* Added support for comparison to a fixture file

## [v0.6.1](https://github.com/cucumber/aruba/compare/v0.6.0...v0.6.1)
* Added support for ruby 2.1.2
* Added support for ~ expansion
* Added support for with_env

## [v0.6.0](https://github.com/cucumber/aruba/compare/v0.5.4...v0.6.0)
* Dropped support for ruby 1.8
* Added support for ruby 2.1.0 and 2.1.1
* Added rspec 3.0.0 support

## [v0.5.4](https://github.com/cucumber/aruba/compare/v0.5.3...v0.5.4)
* Added support for piping in files ([#154](https://github.com/cucumber/aruba/issues/154), [maxmeyer](https://github.com/maxmeyer), dg-vrnetze)
* Added cucumber steps for environment variables ([#156](https://github.com/cucumber/aruba/issues/156), dg-vrnetze)
* Added support for file mode ([#157](https://github.com/cucumber/aruba/issues/157), [maxmeyer](https://github.com/maxmeyer), dg-vrnetze)

## [v0.5.3](https://github.com/cucumber/aruba/compare/v0.5.2...v0.5.3)
* Fix for UTF-8 support ([#151](https://github.com/cucumber/aruba/issues/151), [mattwynne](https://github.com/mattwynne), [jarl-dk](https://github.com/jarl-dk))
* Fix for open file leakage ([#150](https://github.com/cucumber/aruba/issues/150), [jonrowe](https://github.com/JonRowe))

## [v0.5.2](https://github.com/cucumber/aruba/compare/v0.5.1...v0.5.2)

* Plugin API for greater speed. Test Ruby CLI programs in a single Ruby process ([#148](https://github.com/cucumber/aruba/issues/148), [aslakhellesoy](https://github.com/aslakhellesoy))
* Fix memory leak when several commands are executed in a single run ([#144](https://github.com/cucumber/aruba/issues/144), [y-higuchi](https://github.com/y-higuchi))

## [v0.5.1](https://github.com/cucumber/aruba/compare/v0.5.0...v0.5.1)
* Individual timeout settings when running commands ([#124](https://github.com/cucumber/aruba/issues/124), [jarl-dk](https://github.com/jarl-dk))
* Varous fixes for JRuby tests, should now work on more versions of JRuby

## [v0.5.0](https://github.com/cucumber/aruba/compare/v0.4.10...v0.5.0)
* Add #with_file_content to the DSL ([#110](https://github.com/cucumber/aruba/issues/110), [argent-smith](https://github.com/argent-smith))
* Make JRuby performance tweaks optional ([#102](https://github.com/cucumber/aruba/issues/102), [taylor](https://github.com/taylor), [#125](https://github.com/cucumber/aruba/issues/125), [alindeman](https://github.com/alindeman))
* Add assert_partial_output_interactive so you can peek at the output from a running process ([#104](https://github.com/cucumber/aruba/issues/104), [taylor](https://github.com/taylor))
* Add assert_not_matching_output ([#111](https://github.com/cucumber/aruba/issues/111), [argent-smith](https://github.com/argent-smith))
* Add remove_dir ([#121](https://github.com/cucumber/aruba/issues/121), [LTe](https://github.com/LTe))

## [v0.4.11](https://github.com/cucumber/aruba/compare/v0.4.10...v0.4.11)
* Fix duplicated output ([#91](https://github.com/cucumber/aruba/issues/91), [robertwahler](https://github.com/robertwahler), [mattwynne](https://github.com/mattwynne))
* Fix Gemspec format ([#101](https://github.com/cucumber/aruba/issues/101), [mattwynne](https://github.com/mattwynne))

## [v0.4.10](https://github.com/cucumber/aruba/compare/v0.4.9...v0.4.10)
* Fix broken JRuby file following rename of hook ([tdreyno](https://github.com/tdreyno))
* Add terminate method to API ([taylor](https://github.com/taylor))

## [v0.4.9](https://github.com/cucumber/aruba/compare/v0.4.8...v0.4.9)
* Rename before_run hook to before_cmd ([mattwynne](https://github.com/mattwynne))
* Fix 1.8.7 compatibility ([#95](https://github.com/cucumber/aruba/issues/95), [davetron5000](https://github.com/davetron5000))

## [v0.4.8](https://github.com/cucumber/aruba/compare/v0.4.7...v0.4.8)

* Add before_run hook ([mattwynne](https://github.com/mattwynne))
* Add JRuby performance tweaks ([#93](https://github.com/cucumber/aruba/issues/93), [myronmarston](https://github.com/myronmarston), [mattwynne](https://github.com/mattwynne))
* Invalid/Corrupt spec file for 0.4.7 - undefined method call for nil:Nilclass ([#47](https://github.com/cucumber/aruba/issues/47), [aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.4.7](https://github.com/cucumber/aruba/compare/v0.4.6...v0.4.7)

* Remove rdiscount dependency. ([#85](https://github.com/cucumber/aruba/issues/85), [aslakhellesoy](https://github.com/aslakhellesoy))
* Pin to ffi 1.0.9 since 1.0.10 is broken. ([aslakhellesoy](https://github.com/aslakhellesoy))
* Added file size specific steps to the Aruba API. ([#89](https://github.com/cucumber/aruba/issues/89), [hectcastro](https://github.com/hectcastro))

## [v0.4.6](https://github.com/cucumber/aruba/compare/v0.4.5...v0.4.6)

* Upgraded deps to latest gems. ([aslakhellesoy](https://github.com/aslakhellesoy))
* Added Regexp support to Aruba::Api#assert_no_partial_output  ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.4.5](https://github.com/cucumber/aruba/compare/v0.4.4...v0.4.5)

* Better assertion failure message when an exit code is not as expected. ([mattwynne](https://github.com/mattwynne))

## [v0.4.4](https://github.com/cucumber/aruba/compare/v0.4.3...v0.4.4)

* Fix various bugs with interative processes. ([mattwynne](https://github.com/mattwynne))

## [v0.4.3](https://github.com/cucumber/aruba/compare/v0.4.2...v0.4.3)

* Aruba reporting now creates an index file for reports, linking them all together. ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.4.2](https://github.com/cucumber/aruba/compare/v0.4.1...v0.4.2)

* Appending to a file creates the parent directory if it doesn't exist. ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.4.1](https://github.com/cucumber/aruba/compare/v0.4.0...v0.4.1)

* Move more logic into Aruba::Api ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.4.0](https://github.com/cucumber/aruba/compare/v0.3.7...v0.4.0)

* New, awesome HTML reporting feature that captures everything that happens during a scenario. ([aslakhellesoy](https://github.com/aslakhellesoy))
* ANSI escapes from output are stripped by default. Override this with the @ansi tag. ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.3.7](https://github.com/cucumber/aruba/compare/v0.3.6...v0.3.7)

* Make Aruba::Api#get_process return the last executed process with passed cmd ([greyblake](https://github.com/greyblake))
* Replace announce with puts to comply with cucumber 0.10.6 ([aslakhellesoy](https://github.com/aslakhellesoy))
* Fix childprocess STDIN to be synchronous ([#40](https://github.com/cucumber/aruba/issues/40), [#71](https://github.com/cucumber/aruba/issues/71), [lithium3141](https://github.com/lithium3141))

## [v0.3.6](https://github.com/cucumber/aruba/compare/v0.3.5...v0.3.6)

* Changed default value of @aruba_timeout_seconds from 1 to 3. ([aslakhellesoy](https://github.com/aslakhellesoy))
* Separate hooks and steps to make it easier to build your own steps on top of Aruba's API ([msassak](https://github.com/msassak))
* @no-clobber to prevent cleanup before each scenario ([msassak](https://github.com/msassak))

## [v0.3.5](https://github.com/cucumber/aruba/compare/v0.3.4...v0.3.5)

* Store processes in an array to ensure order of operations on Ruby 1.8.x ([#48](https://github.com/cucumber/aruba/issues/48) [msassak](https://github.com/msassak))

## [v0.3.4](https://github.com/cucumber/aruba/compare/v0.3.3...v0.3.4)

* Use backticks (\`) instead of quotes (") to specify command line. Quote still works, but is deprecated. ([aeden](https://github.com/aeden), [aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.3.3](https://github.com/cucumber/aruba/compare/v0.3.2...v0.3.3)

* Updated RSpec development requirement to 2.5 ([rspeicher](https://github.com/rspeicher), [msassak](https://github.com/msassak), [aslakhellesoy](https://github.com/aslakhellesoy))
* Updated RubyGems dependency to 1.6.1 ([rspeicher](https://github.com/rspeicher))

## [v0.3.2](https://github.com/cucumber/aruba/compare/v0.3.1...v0.3.2)

* Wrong number of args in the When I overwrite step ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.3.1](https://github.com/cucumber/aruba/compare/v0.3.0...v0.3.1)

* Broken 0.3.0 release ([#43](https://github.com/cucumber/aruba/issues/43), [#44](https://github.com/cucumber/aruba/issues/44), [msassak](https://github.com/msassak))
* Quotes (") and newline (\n) in step arguments are no longer unescaped. ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.3.0](https://github.com/cucumber/aruba/compare/v0.2.8...v0.3.0)

* Remove latency introduced in the 0.2.8 release ([#42](https://github.com/cucumber/aruba/issues/42), [msassak](https://github.com/msassak))
* New stepdef Then /^the stdout should contain:$/ do |partial_output| ([aslakhellesoy](https://github.com/aslakhellesoy))
* Quotes (") and newline (\n) in step arguments no longer need to be backslash-escaped. ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.2.8](https://github.com/cucumber/aruba/compare/v0.2.7...v0.2.8)

* Replaced background_process with childprocess, a cross-platform process control library. This will allow Aruba to run on Windows and JRuby in addition to *nix MRI. ([#16](https://github.com/cucumber/aruba/issues/16), [#27](https://github.com/cucumber/aruba/issues/27), [#31](https://github.com/cucumber/aruba/issues/31), [msassak](https://github.com/msassak), [jarib](https://github.com/jarib), [mattwynne](https://github.com/mattwynne), [aknuds1](https://github.com/aknuds1))

## [v0.2.7](https://github.com/cucumber/aruba/compare/v0.2.6...v0.2.7)

* Upgrade to Cucumber 0.10.0. ([aslakhellesoy](https://github.com/aslakhellesoy))
* require 'aruba' does nothing - you have to require 'aruba/cucumber' now. This is to prevent bundler from loading it when we don't want to. ([aslakhellesoy](https://github.com/aslakhellesoy))
* Outputting a lot of data causes process to time out ([#30](https://github.com/cucumber/aruba/issues/30), [msassak](https://github.com/msassak))

## [v0.2.6](https://github.com/cucumber/aruba/compare/v0.2.5...v0.2.6)

* You can set @aruba_timeout_seconds in a Before hook to tell Aruba to wait for a process to complete. Default: 1 second. ([aslakhellesoy](https://github.com/aslakhellesoy))
* Fixed small bug in /^the stdout should contain exactly:$/ ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.2.5](https://github.com/cucumber/aruba/compare/v0.2.4...v0.2.5)

* Added 'a file named "whatever" should (not) exist' ([rspeicher](https://github.com/rspeicher))
* Added 'a directory named "whatever" should (not) exist' ([rspeicher](https://github.com/rspeicher))
* Added /^the stderr should contain exactly:"$/ ([aslakhellesoy](https://github.com/aslakhellesoy))
* Added /^the stdout should contain exactly:"$/ ([aslakhellesoy](https://github.com/aslakhellesoy))
* Added /it should pass with exactly:/ ([aslakhellesoy](https://github.com/aslakhellesoy))
* @announce, @announce-dir and @announce-cmd for interactive processes ([msassak](https://github.com/msassak))
* Add step defs for detecting output, stdout and stderr by process name ([msassak](https://github.com/msassak))
* Stop all processes before verifying filesystem changes to ensure async operations are complete ([#17](https://github.com/cucumber/aruba/issues/17), [msassak](https://github.com/msassak))
* Outputting large amounts of data causes run steps to hang ([#18](https://github.com/cucumber/aruba/issues/18), [msassak](https://github.com/msassak))

## [v0.2.4](https://github.com/cucumber/aruba/compare/v0.2.3...v0.2.4)

* Added step definitions for removing files and checking presence of a single file. ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.2.3](https://github.com/cucumber/aruba/compare/v0.2.2...v0.2.3)

* Directory should not exist gives false-positive ([#13](https://github.com/cucumber/aruba/issues/13), [#15](https://github.com/cucumber/aruba/issues/15), [nruth](https://github.com/nruth))
* Added step definitions for comparing file contents with regexps ([#9](https://github.com/cucumber/aruba/issues/9), [aslakhellesoy](https://github.com/aslakhellesoy))
* Always put ./bin at the beginning of $PATH to make it easier to run own executables ([#7](https://github.com/cucumber/aruba/issues/7), [aslakhellesoy](https://github.com/aslakhellesoy))
* Communication with interactive processes ([#4](https://github.com/cucumber/aruba/issues/4), [msassak](https://github.com/msassak))
* Remove hyphens separating stdout and stderr ([aknuds1](https://github.com/aknuds1))

## [v0.2.2](https://github.com/cucumber/aruba/compare/v0.2.1...v0.2.2)

* Added a @bin tag that sets up './bin' first on the path ([aslakhellesoy](https://github.com/aslakhellesoy))
* Richer API making aruba easier to use from Ruby code. (Mark Nijhof, [aslakhellesoy](https://github.com/aslakhellesoy))
* No more support for RVM. Use rvm 1.9.2,1.8.7 exec cucumber .... instead. (Mark Nijhof, [aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.2.1](https://github.com/cucumber/aruba/compare/v0.2.0...v0.2.1)

* Always compare with RSpec should =~ instead of should match. This gives a diff when there is no match. ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.2.0](https://github.com/cucumber/aruba/compare/v0.1.9...v0.2.0)

* Added aruba.gemspec. ([dchelimsky](https://github.com/dchelimsky))
* Several step definitions regarding output have changed. ([#1](https://github.com/cucumber/aruba/issues/1), [aslakhellesoy](https://github.com/aslakhellesoy))

    - /^I should see "([^\"]*)"$/
    + /^the output should contain "([^"]*)"$/

    - /^I should not see "([^\"]*)"$/
    + /^the output should not contain "([^"]*)"$/

    - /^I should see:$/
    + /^the output should contain:$/

    - /^I should not see:$/
    + /^the output should not contain:$/

    - /^I should see exactly "([^\"]*)"$/
    + /^the output should contain exactly "([^"]*)"$/

    - /^I should see exactly:$/
    + /^the output should contain exactly:$/

    - /^I should see matching \/([^\/]*)\/$/
    + /^the output should match \/([^\/]*)\/$/

    - /^I should see matching:$/
    + /^the output should match:$/

## [v0.1.9](https://github.com/cucumber/aruba/compare/v0.1.8...v0.1.9)

* If the GOTGEMS environment variable is set, bundler won't run (faster). ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.1.8](https://github.com/cucumber/aruba/compare/v0.1.7...v0.1.8)

* Use // instead of "" for "I should see matching" step. ([aslakhellesoy](https://github.com/aslakhellesoy))
* Replace rvm gemset character '%' with '@' for rvm 0.1.24 ([#5](https://github.com/cucumber/aruba/issues/5), Ashley Moran)
* Support gem bundler, making it easier to specify gems. ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.1.7](https://github.com/cucumber/aruba/compare/v0.1.6...v0.1.7)

* New @announce-stderr tag ([robertwahler](https://github.com/robertwahler))
* New "I should see matching" steps using Regexp ([robertwahler](https://github.com/robertwahler))

## [v0.1.6](https://github.com/cucumber/aruba/compare/v0.1.5...v0.1.6)

* When /^I successfully run "(.*)"$/ now prints the combined output if exit status is not 0. ([aslakhellesoy](https://github.com/aslakhellesoy))
* Add bundle to list of common ruby scripts. ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.1.5](https://github.com/cucumber/aruba/compare/v0.1.4...v0.1.5)

* Added ability to map rvm versions to a specific version with config/aruba-rvm.yml. ([aslakhellesoy](https://github.com/aslakhellesoy))
* Check for presence of files. ([aslakhellesoy](https://github.com/aslakhellesoy))
* Allow specification of rvm gemsets. ([aslakhellesoy](https://github.com/aslakhellesoy))
* Detect ruby commands and use current ruby when rvm is not explicitly used. ([aslakhellesoy](https://github.com/aslakhellesoy))
* Added support for rvm, making it possible to choose Ruby interpreter. ([aslakhellesoy](https://github.com/aslakhellesoy))
* Added @announce-cmd, @announce-stdout and @announce tags, useful for seeing what's executed and outputted. ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.1.4](https://github.com/cucumber/aruba/compare/v0.1.3...v0.1.4)

* New step definition for appending to a file ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.1.3](https://github.com/cucumber/aruba/compare/v0.1.2...v0.1.3)

* New step definition for cd (change directory) ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.1.2](https://github.com/cucumber/aruba/compare/v0.1.1...v0.1.2)

* Separated API from Cucumber step definitions, makes this usable without Cucumber. ([aslakhellesoy](https://github.com/aslakhellesoy))

## [v0.1.1](https://github.com/cucumber/aruba/compare/v0.1.0...v0.1.1)

* Better Regexp escaping ([dchelimsky](https://github.com/dchelimsky))

## [v0.1.0](https://github.com/cucumber/aruba/compare/ed6a175d23aaff62dbf355706996f276f304ae8b...v0.1.1)

* First release ([dchelimsky](https://github.com/dchelimsky) and [aslakhellesoy](https://github.com/aslakhellesoy))
