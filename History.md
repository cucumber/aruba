#  RELEASED

## [v0.14.6](https://github.com/cucumber/aruba/compare/v0.14.5...v0.14.6)

* Document and fix `@disable-bundler` hook (#561)
* Deprecate `have_same_file_content_like` and `a_file_with_same_content_like`
  in favor of `have_same_file_content_as` and `a_file_with_same_content_as` (#557)

## [v0.14.5](https://github.com/cucumber/aruba/compare/v0.14.4...v0.14.5)

* Loosen dependency on child_process (#551)

## [v0.14.4](https://github.com/cucumber/aruba/compare/v0.14.3...v0.14.4)

* Fix command spawning when run in directories with spaces (#490)
* Ensure setup is still done when using `@no-clobber` (#529)
* Make `#expand_path` handle absolute paths correctly (#486)

## [v0.14.3](https://github.com/cucumber/aruba/compare/v0.14.2...v0.14.3)

* Fix path bug (#422)
* Ensure non-deprecated methods do not use deprecated methods
* Update dependency on childprocess
* Fix encoding output on JRuby

## [v0.14.2](https://github.com/cucumber/aruba/compare/v0.14.1...v0.14.2)

* Handle empty JRUBY_OPTS on JRuby

## [v0.14.1](https://github.com/cucumber/aruba/compare/v0.14.0...v0.14.1)

* Fixed bug in framework step

## [v0.14.0](https://github.com/cucumber/aruba/compare/v0.13.0...v0.14.0)

* Add `<project_root>/exe` to search path for commands: This is the new default if you setup a
  project with bundler.
* Add some more steps to modify environment

## [v0.13.0](https://github.com/cucumber/aruba/compare/v0.12.0...v0.13.0)

* Add two new hooks for rspec and cucumber to make troubleshooting feature
  files easier (PR #338):
  * command_content: Outputs command content - helpful for scripts
  * command_filesystem_status: Outputs information like group, owner, mode,
    atime, mtime
* Add generator to create ad hoc script file (PR #323, @AdrieanKhisbe)
* Colored announcer output similar to the color of `cucumber` tags: cyan
* Fixed bug in announcer. It announces infomation several times due to
  duplicate announce-calls.
* Refactorings to internal `#simple_table`-method (internal)
* Refactored Announcer, now it supports blocks for announce as well (internal)
* Fix circular require warnings (issue #339)
* Fix use of old instances variable "@io_wait" (issue #341). Now the
  default value for io_wait_timeout can be set correctly.
* Make it possible to announce information on command error, using a new option
  called `activate_announcer_on_command_failure` (PR #335, @njam)
* Re-integrate `event-bus`-library into `aruba`-core (PR #342)

## [v0.12.0](https://github.com/cucumber/aruba/compare/v0.11.2...v0.12.0)

* Add matcher to check if a command can be found in PATH (PR #336)
* Fixed issue with environment variables set by external libraries (fix #321,
  issue #320)

# Old releases

## [v0.11.2](https://github.com/cucumber/aruba/compare/v0.11.1...v0.11.2)

* Fixed problem with positional arguments in `#run_simple()` (issue #322)


## [v0.11.1](https://github.com/cucumber/aruba/compare/v0.11.0...v0.11.1)

* Use fixed version of event-bus
* Refactored and improved documentation (feature tests) in PR #309

## [v0.11.0](https://github.com/cucumber/aruba/compare/v0.11.0.pre4...v0.11.0)

* Accidently pushed to rubygems.org - yanked it afterwards

## [v0.11.0.pre4](https://github.com/cucumber/aruba/compare/v0.11.0.pre3...v0.11.0.pre4)

* Fixed syntax for Hash on ruby 1.8.7
* Reorder rubies in .travis.yml

## [v0.11.0.pre3](https://github.com/cucumber/aruba/compare/v0.11.0.pre2...v0.11.0.pre3)

* Fixed syntax for proc on ruby 1.8.7

## [v0.11.0.pre2](https://github.com/cucumber/aruba/compare/v0.11.0.pre...v0.11.0.pre2)

* Integrate `EventBus` to decouple announcers from starting, stopping commands
  etc. This uses nearly the same implementation like `cucumber`. (PR #309)
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

* Fix '"#exit_timeout" is deprecated' error (issue #314)

## [v0.10.0.pre2](https://github.com/cucumber/aruba/compare/v0.10.0.pre...v0.10.0.pre2)

* Take over code from `RSpec::Support::ObjectFormatter` since `rspec-support`
  is not intended for public use.

## [v0.10.0.pre](https://github.com/cucumber/aruba/compare/v0.9.0...v0.10.0)

* Add some new steps to make writing documentation easier using "cucumber",
  "rspec", "minitest" together with "aruba" - see [Feature](features/getting_started/supported_testing_frameworks.feature)
  for some examples
* Write output of commands directly to disk if SpawnProcess is used (see https://github.com/cucumber/aruba/commit/85d74fcca4fff4e753776925d8b003cddaa8041d)
* Refactored API of cucumber steps to reduce the need for more methods and make
  it easier for users to write their own steps (issue #306)
* Added `aruba init` to the cli command to setup environment for aruba (issue
  #308)
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
* Add a lot of documentation (issue #260)
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
* Fix incorrect deprecation message for check_file_presence (issue #292)
* Fix for Gemfile excludes windows for many gems (issue #282)
* Make feature tests compatible with ruby 1.9.2
* Gather disk usage for file(s) (issue #294)
* Replace keep_ansi-config option by remove_ansi_escape_sequences-option
* Split up `#unescape` into `#extract_text` and `#unescape_text`
* Use `UnixPlatform` and `WindowsPlatform` to make code for different platforms maintainable
* Work around `ENV`-bug in `Jruby` buy using `#dup` on `ENV.to_h` (issue jruby/jruby#3162)
* Speed up test on `JRuby` by using `--dev`-flag
* Work around problems when copying files with `cp` on MRI-ruby 1.9.2
* Add cmd.exe /c for SpawnProcess on Windows (issue #302)
* Split up `#which` for Windows and Unix/Linux (issue #304)
* Add `aruba console`-command to play around with aruba (issue 305)


## [v0.8.1](https://github.com/cucumber/aruba/compare/v0.8.0...v0.8.1)

* Fix problem if working directory of aruba does not exist (issue #286)
* Re-Add removed method only_processes
* Fixed problem with last exit status
* Added appveyor to run tests of aruba on Windows (issue #287)
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
* Make aruba compatible with "ruby 1.8.7" and "ruby 1.9.3" again (fixes #279)
* Move more and more documentation to cucumber steps (partly fixes #268)
* Refactoring of test suits, now rspec tests run randomly
* Move Aruba constants to configuration class (fixes #271)
* Added runtime configuration via `aruba.config` which is reset for each test run
* Refactored hooks: now there are `after()` and `before()`-hooks, old
  before_cmd-hook is still working, but is deprecated, added new
  `after(:command)`-hook.
* Refactored jruby-startup helper
* Cleanup API by moving deprecated methods to separate class
* Cleanup Core API - reduced to `cd`, `expand_path`, `setup_aruba` and use expand_path wherever possible (fixes #253)
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
* Do not trigger Announcer API deprecation warning (issue #277)

## [v0.7.1](https://github.com/cucumber/aruba/compare/v0.7.0...v0.7.1)
* Do not break if @interactive is used

## [v0.7.0](https://github.com/cucumber/aruba/compare/v0.6.2...v0.7.0)
* Introducing root_directory (issue #232)
* Introducing fixtures directory (issue #224)
* Make sure a file/directory does not exist + Cleanup named file/directory steps (issue #234)
* Make matcher have_permisions public and add documentation (issue #239)
* Added matcher for file content (issue #238)
* Add rspec integrator (issue #244)
* Deprecate _file/_directory in method names (issue #243)
* Improve development environment (issue #240)
* Cleanup process management (issue #257)
* Make path content available through matchers and api metchods (issue #250)
* Refactor announcer to support user defined announce channels (fixes #267)
* `InProcess` requires that the working directory is determined on runtime not no loadtime

## [v0.6.2](https://github.com/cucumber/aruba/compare/v0.6.1...v0.6.2)
* Fixed minor issue #223)
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
* Added support for piping in files (#154 maxmeyer, dg-vrnetze)
* Added cucumber steps for environment variables (#156 dg-vrnetze)
* Added support for file mode (#157 maxmeyer, dg-vrnetze)

## [v0.5.3](https://github.com/cucumber/aruba/compare/v0.5.2...v0.5.3)
* Fix for UTF-8 support (#151 Matt Wynne, Jarl Friis)
* Fix for open file leakage (#150 @JonRowe)

## [v0.5.2](https://github.com/cucumber/aruba/compare/v0.5.1...v0.5.2)

* Plugin API for greater speed. Test Ruby CLI programs in a single Ruby process (#148 Aslak Hellesøy)
* Fix memory leak when several commands are executed in a single run (#144 @y-higuchi)

## [v0.5.1](https://github.com/cucumber/aruba/compare/v0.5.0...v0.5.1)
* Individual timeout settings when running commands (#124 Jarl Friis)
* Varous fixes for JRuby tests, should now work on more versions of JRuby

## [v0.5.0](https://github.com/cucumber/aruba/compare/v0.4.10...v0.5.0)
* Add #with_file_content to the DSL (#110 Pavel Argentov)
* Make JRuby performance tweaks optional (#102 Taylor Carpenter, #125 Andy Lindeman)
* Add assert_partial_output_interactive so you can peek at the output from a running process (#104 Taylor Carpenter)
* Add assert_not_matching_output (#111 Pavel Argentov)
* Add remove_dir (#121 Piotr Niełacny)

## [v0.4.11](https://github.com/cucumber/aruba/compare/v0.4.10...v0.4.11)
* Fix duplicated output (#91 Robert Wahler, Matt Wynne)
* Fix Gemspec format (#101 Matt Wynne)

## [v0.4.10](https://github.com/cucumber/aruba/compare/v0.4.9...v0.4.10)
* Fix broken JRuby file following rename of hook (Thomas Reynolds)
* Add terminate method to API (Taylor Carpenter)

## [v0.4.9](https://github.com/cucumber/aruba/compare/v0.4.8...v0.4.9)
* Rename before_run hook to before_cmd (Matt Wynne)
* Fix 1.8.7 compatibility (#95 Dave Copeland)

## [v0.4.8](https://github.com/cucumber/aruba/compare/v0.4.7...v0.4.8)

* Add before_run hook (Matt Wynne)
* Add JRuby performance tweaks (#93 Myron Marston / Matt Wynne)
* Invalid/Corrupt spec file for 0.4.7 - undefined method call for nil:Nilclass (#47 Aslak Hellesøy)

## [v0.4.7](https://github.com/cucumber/aruba/compare/v0.4.6...v0.4.7)

* Remove rdiscount dependency. (#85 Aslak Hellesøy)
* Pin to ffi 1.0.9 since 1.0.10 is broken. (Aslak Hellesøy)
* Added file size specific steps to the Aruba API. (#89 Hector Castro)

## [v0.4.6](https://github.com/cucumber/aruba/compare/v0.4.5...v0.4.6)

* Upgraded deps to latest gems. (Aslak Hellesøy)
* Added Regexp support to Aruba::Api#assert_no_partial_output  (Aslak Hellesøy)

## [v0.4.5](https://github.com/cucumber/aruba/compare/v0.4.4...v0.4.5)

* Better assertion failure message when an exit code is not as expected. (Matt Wynne)

## [v0.4.4](https://github.com/cucumber/aruba/compare/v0.4.3...v0.4.4)

* Fix various bugs with interative processes. (Matt Wynne)

## [v0.4.3](https://github.com/cucumber/aruba/compare/v0.4.2...v0.4.3)

* Aruba reporting now creates an index file for reports, linking them all together. (Aslak Hellesøy)

## [v0.4.2](https://github.com/cucumber/aruba/compare/v0.4.1...v0.4.2)

* Appending to a file creates the parent directory if it doesn't exist. (Aslak Hellesøy)

## [v0.4.1](https://github.com/cucumber/aruba/compare/v0.4.0...v0.4.1)

* Move more logic into Aruba::Api (Aslak Hellesøy)

## [v0.4.0](https://github.com/cucumber/aruba/compare/v0.3.7...v0.4.0)

* New, awesome HTML reporting feature that captures everything that happens during a scenario. (Aslak Hellesøy)
* ANSI escapes from output are stripped by default. Override this with the @ansi tag. (Aslak Hellesøy)

## [v0.3.7](https://github.com/cucumber/aruba/compare/v0.3.6...v0.3.7)

* Make Aruba::Api#get_process return the last executed process with passed cmd (Potapov Sergey)
* Replace announce with puts to comply with cucumber 0.10.6 (Aslak Hellesøy)
* Fix childprocess STDIN to be synchronous (#40, #71 Tim Ekl)

## [v0.3.6](https://github.com/cucumber/aruba/compare/v0.3.5...v0.3.6)

* Changed default value of @aruba_timeout_seconds from 1 to 3. (Aslak Hellesøy)
* Separate hooks and steps to make it easier to build your own steps on top of Aruba's API (Mike Sassak)
* @no-clobber to prevent cleanup before each scenario (Mike Sassak)

## [v0.3.5](https://github.com/cucumber/aruba/compare/v0.3.4...v0.3.5)

* Store processes in an array to ensure order of operations on Ruby 1.8.x (#48 Mike Sassak)

## [v0.3.4](https://github.com/cucumber/aruba/compare/v0.3.3...v0.3.4)

* Use backticks (\`) instead of quotes (") to specify command line. Quote still works, but is deprecated. (Anthony Eden, Aslak Hellesøy)

## [v0.3.3](https://github.com/cucumber/aruba/compare/v0.3.2...v0.3.3)

* Updated RSpec development requirement to 2.5 (Robert Speicher, Mike Sassak, Aslak Hellesøy)
* Updated RubyGems dependency to 1.6.1 (Robert Speicher)

## [v0.3.2](https://github.com/cucumber/aruba/compare/v0.3.1...v0.3.2)

* Wrong number of args in the When I overwrite step (Aslak Hellesøy)

## [v0.3.1](https://github.com/cucumber/aruba/compare/v0.3.0...v0.3.1)

* Broken 0.3.0 release (#43, #44 Mike Sassak)
* Quotes (") and newline (\n) in step arguments are no longer unescaped. (Aslak Hellesøy)

## [v0.3.0](https://github.com/cucumber/aruba/compare/v0.2.8...v0.3.0)

* Remove latency introduced in the 0.2.8 release (#42 Mike Sassak)
* New stepdef Then /^the stdout should contain:$/ do |partial_output| (Aslak Hellesøy)
* Quotes (") and newline (\n) in step arguments no longer need to be backslash-escaped. (Aslak Hellesøy)

## [v0.2.8](https://github.com/cucumber/aruba/compare/v0.2.7...v0.2.8)

* Replaced background_process with childprocess, a cross-platform process control library. This will allow Aruba to run on Windows and JRuby in addition to *nix MRI. (#16, #27, #31 Mike Sassak, Jari Bakken, Matt Wynne, Arve Knudsen)

## [v0.2.7](https://github.com/cucumber/aruba/compare/v0.2.6...v0.2.7)

* Upgrade to Cucumber 0.10.0. (Aslak Hellesøy)
* require 'aruba' does nothing - you have to require 'aruba/cucumber' now. This is to prevent bundler from loading it when we don't want to. (Aslak Hellesøy)
* Outputting a lot of data causes process to time out (#30 Mike Sassak)

## [v0.2.6](https://github.com/cucumber/aruba/compare/v0.2.5...v0.2.6)

* You can set @aruba_timeout_seconds in a Before hook to tell Aruba to wait for a process to complete. Default: 1 second. (Aslak Hellesøy)
* Fixed small bug in /^the stdout should contain exactly:$/ (Aslak Hellesøy)

## [v0.2.5](https://github.com/cucumber/aruba/compare/v0.2.4...v0.2.5)

* Added 'a file named "whatever" should (not) exist' (Robert Speicher)
* Added 'a directory named "whatever" should (not) exist' (Robert Speicher)
* Added /^the stderr should contain exactly:"$/ (Aslak Hellesøy)
* Added /^the stdout should contain exactly:"$/ (Aslak Hellesøy)
* Added /it should pass with exactly:/ (Aslak Hellesøy)
* @announce, @announce-dir and @announce-cmd for interactive processes (Mike Sassak)
* Add step defs for detecting output, stdout and stderr by process name (Mike Sassak)
* Stop all processes before verifying filesystem changes to ensure async operations are complete (#17 Mike Sassak)
* Outputting large amounts of data causes run steps to hang (#18 Mike Sassak)

## [v0.2.4](https://github.com/cucumber/aruba/compare/v0.2.3...v0.2.4)

* Added step definitions for removing files and checking presence of a single file. (Aslak Hellesøy)

## [v0.2.3](https://github.com/cucumber/aruba/compare/v0.2.2...v0.2.3)

* Directory should not exist gives false-positive (#13,#15 Nicholas Rutherford)
* Added step definitions for comparing file contents with regexps (#9 Aslak Hellesøy)
* Always put ./bin at the beginning of $PATH to make it easier to run own executables (#7 Aslak Hellesøy)
* Communication with interactive processes (#4 Mike Sassak)
* Remove hyphens separating stdout and stderr (Arve Knudsen)

## [v0.2.2](https://github.com/cucumber/aruba/compare/v0.2.1...v0.2.2)

* Added a @bin tag that sets up './bin' first on the path (Aslak Hellesøy)
* Richer API making aruba easier to use from Ruby code. (Mark Nijhof, Aslak Hellesøy)
* No more support for RVM. Use rvm 1.9.2,1.8.7 exec cucumber .... instead. (Mark Nijhof, Aslak Hellesøy)

## [v0.2.1](https://github.com/cucumber/aruba/compare/v0.2.0...v0.2.1)

* Always compare with RSpec should =~ instead of should match. This gives a diff when there is no match. (Aslak Hellesøy)

## [v0.2.0](https://github.com/cucumber/aruba/compare/v0.1.9...v0.2.0)

* Added aruba.gemspec. (David Chelimsky)
* Several step definitions regarding output have changed. (#1 Aslak Hellesøy)

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

* If the GOTGEMS environment variable is set, bundler won't run (faster). (Aslak Hellesøy)

## [v0.1.8](https://github.com/cucumber/aruba/compare/v0.1.7...v0.1.8)

* Use // instead of "" for "I should see matching" step. (Aslak Hellesøy)
* Replace rvm gemset character '%' with '@' for rvm 0.1.24 (#5 Ashley Moran)
* Support gem bundler, making it easier to specify gems. (Aslak Hellesøy)

## [v0.1.7](https://github.com/cucumber/aruba/compare/v0.1.6...v0.1.7)

* New @announce-stderr tag (Robert Wahler)
* New "I should see matching" steps using Regexp (Robert Wahler)

## [v0.1.6](https://github.com/cucumber/aruba/compare/v0.1.5...v0.1.6)

* When /^I successfully run "(.*)"$/ now prints the combined output if exit status is not 0. (Aslak Hellesøy)
* Add bundle to list of common ruby scripts. (Aslak Hellesøy)

## [v0.1.5](https://github.com/cucumber/aruba/compare/v0.1.4...v0.1.5)

* Added ability to map rvm versions to a specific version with config/aruba-rvm.yml. (Aslak Hellesøy)
* Check for presence of files. (Aslak Hellesøy)
* Allow specification of rvm gemsets. (Aslak Hellesøy)
* Detect ruby commands and use current ruby when rvm is not explicitly used. (Aslak Hellesøy)
* Added support for rvm, making it possible to choose Ruby interpreter. (Aslak Hellesøy)
* Added @announce-cmd, @announce-stdout and @announce tags, useful for seeing what's executed and outputted. (Aslak Hellesøy)

## [v0.1.4](https://github.com/cucumber/aruba/compare/v0.1.3...v0.1.4)

* New step definition for appending to a file (Aslak Hellesøy)

## [v0.1.3](https://github.com/cucumber/aruba/compare/v0.1.2...v0.1.3)

* New step definition for cd (change directory) (Aslak Hellesøy)

## [v0.1.2](https://github.com/cucumber/aruba/compare/v0.1.1...v0.1.2)

* Separated API from Cucumber step definitions, makes this usable without Cucumber. (Aslak Hellesøy)

## [v0.1.1](https://github.com/cucumber/aruba/compare/v0.1.0...v0.1.1)

* Better Regexp escaping (David Chelimsky)

## [v0.1.0](https://github.com/cucumber/aruba/compare/ed6a175d23aaff62dbf355706996f276f304ae8b...v0.1.1)

* First release (David Chelimsky and Aslak Hellesøy)
