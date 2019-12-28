# CHANGELOG

All notable changes to this project will be documented in this file.

This project will adhere to [Semantic Versioning][1] once version 1.0.0 is released.

This document is formatted according to the principles of [Keep A CHANGELOG][2].

## [0.14.14]

* Support Ruby 2.7 ([#677])

## [0.14.13]

* Loosen dependency on thor ([#676])
* Mark setting of `root_directory` as deprecated in documentation ([#571])

## [0.14.12]

* Loosen dependency on childprocess ([#673])
* Fix Travis build ([#668])
* Handle announcing with DebugProcess ([#664])

## [0.14.11]

* Loosen childprocess dependency ([#658])
* Do not set binmode on output temp files, so automatic line ending conversion works ([#650])
* Improve deprecation suggestions ([#647])
* Backport fixes to code organization, layout and spelling ([#645])

## [0.14.10]

* Backport replacement of problematic AnsiColor module with simple
  implementation ([#642])
* Undo preprecation of `#all_output`, `#all_stdout`, `#all_stderr` and
  `#in_current_directory` API methods, as well as of checking the combined
  output from all commands in cucumber steps ([#638])
* Warn when deprecated files `aruba/in_process` and `aruba/spawn_process` are
  required ([#639])
* Backport allowing decimal timeout values ([#621])
* Move deprecated cucumber steps into a separate file ([#622])
* Backport renaming of bin/cli in features ([#620])
* Improve build set for CI ([#611])
* Make JRuby before :command helper hook work on the environment the command
  will actually be run in ([#610], [#612])
* Reorganize spec files to match master branch ([#603])
* Reorganize feature files to match master branch ([#602])

## [0.14.9]

* Formally deprecate `#use_clean_gemset` ([#597])
* Improve deprecation messages ([#601])
* Do not replace entire environment inside `#cd` block ([#604])

## [0.14.8]

* Deprecate `#run` and `#run_simple` in favor of `#run_command` and
  `#run_command_and_stop` ([#585])
* Update dependencies, most notably loosening the dependency on `childprocess`
  ([#591])
* Properly warn about deprecated use of the run methods with one positional
  option ([#588])

## [0.14.7]

* Fix Cucumber steps to use `have_same_file_content_as` matcher ([#572])
* Update dependencies, most notably loosening the dependency on `ffi` ([#581])

## [0.14.6]

* Document and fix `@disable-bundler` hook ([#561])
* Deprecate `have_same_file_content_like` and `a_file_with_same_content_like`
  in favor of `have_same_file_content_as` and `a_file_with_same_content_as` ([#557])

## [0.14.5]

* Loosen dependency on child_process ([#551])

## [0.14.4]

* Fix command spawning when run in directories with spaces ([#490])
* Ensure setup is still done when using `@no-clobber` ([#529])
* Make `#expand_path` handle absolute paths correctly ([#486])

## [0.14.3]

* Fix path bug ([#422])
* Ensure non-deprecated methods do not use deprecated methods ([#489])
* Update dependency on childprocess ([#516])
* Fix encoding output on JRuby ([#516])

## [0.14.2]

* Handle empty `JRUBY_OPTS` on JRuby

## [0.14.1]

* Fixed bug in framework step

## [0.14.0]

* Add `<project_root>/exe` to search path for commands: This is the new default
  if you setup a project with bundler.
* Add some more steps to modify environment

## [0.13.0]

* Add two new hooks for rspec and cucumber to make troubleshooting feature
  files easier ([#338]):
  * `command_content`: Outputs command content - helpful for scripts
  * `command_filesystem_status`: Outputs information like group, owner, mode,
    atime, mtime
* Add generator to create ad hoc script file ([#323], [AdrieanKhisbe])
* Colored announcer output similar to the color of `cucumber` tags: cyan
* Fixed bug in announcer. It announces infomation several times due to
  duplicate announce-calls.
* Refactorings to internal `#simple_table`-method (internal)
* Refactored Announcer, now it supports blocks for announce as well (internal)
* Fix circular require warnings ([#339])
* Fix use of old instances variable `@io_wait` ([#341]). Now the
  default value for `io_wait_timeout` can be set correctly.
* Make it possible to announce information on command error, using a new option
  called `activate_announcer_on_command_failure` ([#335], [njam])
* Re-integrate `event-bus`-library into `aruba`-core ([#342])

## [0.12.0]

* Add matcher to check if a command can be found in PATH ([#336])
* Fixed issue with environment variables set by external libraries ([#321], [#320])

## [0.11.2]

* Fixed problem with positional arguments in `#run_simple()` ([#322])

## [0.11.1]

* Use fixed version of event-bus
* Refactored and improved documentation (feature tests) in [#309]

## [0.11.0]

* Accidently pushed to rubygems.org - yanked it afterwards

## [0.11.0.pre4]

* Fixed syntax for Hash on ruby 1.8.7
* Reorder rubies in .travis.yml

## [0.11.0.pre3]

* Fixed syntax for proc on ruby 1.8.7

## [0.11.0.pre2]

* Integrate `EventBus` to decouple announcers from starting, stopping commands
  etc. This uses nearly the same implementation like `cucumber`. ([#309])
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


## [0.11.0.pre]

* Set stop signal which should be used to stop a process after a timeout or
  used to terminate a process. This can be used to stop processes running
  docker + "systemd". If you send a systemd-enable container SIGINT it will be
  stopped.
* Added a configurable amount of time after a command was started -
  `startup_wait_time`. Otherwise you get problems when a process takes to long to
  startup when you run in background and want to sent it a signal.
* Replace `<variable>` in commandline, e.g. `<pid-last-command-started>`
  [experimental]
* Added announce formatter for time spans, e.g. `startup_wait_time`
* All process classes, e.g. `BasicProcess`, `SpawnProcess`, etc., are marked as
  private. Users should use `#run('cmd')` and not use the classes directly.
* `rvm`-methods are deprecated. They are too ruby specific.


## [0.10.2]

* Fixed problem in regex after merge of step definitions


## [0.10.1]

* Merged remove steps for file and directory from 4 into 2 step definitions


## [0.10.0]

* Fix `"#exit_timeout" is deprecated` error ([#314])

## [0.10.0.pre2]

* Take over code from `RSpec::Support::ObjectFormatter` since `rspec-support`
  is not intended for public use.

## [0.10.0.pre]

* Add some new steps to make writing documentation easier using "cucumber",
  "rspec", "minitest" together with "aruba" - see [Feature](features/getting_started/supported_testing_frameworks.feature)
  for some examples
* Write output of commands directly to disk if SpawnProcess is used
  (see [85d74fcc](https://github.com/cucumber/aruba/commit/85d74fcca4fff4e753776925d8b003cddaa8041d))
* Refactored API of cucumber steps to reduce the need for more methods and make
  it easier for users to write their own steps ([#306])
* Added `aruba init` to the cli command to setup environment for aruba (issue
  [#308])
* Added new method `delete_environment_variable` to remove environment variable
* Added work around because of method name conflict between Capybara and RSpec
  ([1939c404](https://github.com/cucumber/aruba/commit/1939c4049d5195ffdd967485f50119bdd86e98a0))


## [0.9.0]

* Fix feature test
* Fix ordering in console
* Fix bug in console handling SIGINT
* Deprecated Aruba/Reporting before we remove it

## [0.9.0.pre2]

* Redefine `#to_s` and `#inspect` for BasicProcess to reduce the sheer amount of
  information, if a command produces a lot of output
* Added new matcher `#all_objects` to check if an object is included + an error
  message for failures which is similar to the `#all`-matcher of `RSpec`
* Add `have_output`-, `have_output_on_stderr`, `have_output_on_stdout`-matchers
* Replace all `assert_*` and `check_*`-methods through expectations
* Add hook `@announce-output` to output both, stderr and stdout
* Add a lot of documentation ([#260])
* Replace `#last_command` through `#last_command_started` and
  `#last_command_stopped` to make it more explicit
* Improve syntax highlighting in cucumber feature tests by adding programming
  language to `"""`-blocks
* Rename tags `@ignore-*` to `@unsupported-on-*`
* Introduce our own `BaseMatcher`-class to remove the dependency to `RSpec`'s
  private matcher APIs
* Now we make the process started via `SpawnProcess` the leader of the group to
  kill all sub-processes more reliably


## [0.9.0.pre]

* Improve documentation for filesystem api and move it to feature tests
* Add logger to aruba. Its output can be captured by rspec.
* Fix incorrect deprecation message for `check_file_presence` ([#292])
* Fix for Gemfile excludes windows for many gems ([#282])
* Make feature tests compatible with ruby 1.9.2
* Gather disk usage for file(s) ([#294])
* Replace `keep_ansi` config option by `remove_ansi_escape_sequences` option
* Split up `#unescape` into `#extract_text` and `#unescape_text`
* Use `UnixPlatform` and `WindowsPlatform` to make code for different platforms
  maintainable
* Work around `ENV`-bug in JRuby by using `#dup` on `ENV.to_h` ([jruby/jruby#316])
* Speed up test on JRuby by using `--dev`-flag
* Work around problems when copying files with `cp` on MRI-ruby 1.9.2
* Add `cmd.exe /c` for SpawnProcess on Windows ([#302])
* Split up `#which` for Windows and Unix/Linux ([#304])
* Add `aruba console` command to play around with aruba ([#305])


## [0.8.1]

* Fix problem if working directory of aruba does not exist ([#286])
* Re-add removed method `only_processes`
* Fixed problem with last exit status
* Added appveyor to run tests of aruba on Windows ([#287])
* Make the home directory configurable and use Around/around-hook to apply it
* Add announcer to output the full environment before a command is run
* Use `prepend_environment_variable` to modify PATH for rspec integration
* Add `VERSION` constant to aruba and use it for code which should be activated on >= 1.0.0

## [0.8.0]

* Build with cucumber 1.3.x on ruby 1.8.7, with cucumber 2.x on all other platforms
* Fixed bugs in aruba's cucumber steps
* Disable use of `win32/file`
* Fixed bug in `in_current_dir*` not returning the result of the block
* Fixed checks for file content
* Fixed selectors for DebugProcess and InProcess to support sub-classes as well


## [0.8.0.pre3]

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

## [0.8.0.pre2]

* Relax requirement on rspec-expectations (3.3 -> 2.11)

## [0.8.0.pre]

* Make aruba compatible with "ruby 1.8.7" and "ruby 1.9.3" again ([#279])
* Move more and more documentation to cucumber steps ([#268])
* Refactoring of test suits, now rspec tests run randomly
* Move Aruba constants to configuration class ([#271])
* Added runtime configuration via `aruba.config` which is reset for each test run
* Refactored hooks: now there are `after()` and `before()`-hooks, old
  `before_cmd`-hook is still working, but is deprecated, added new
  `after(:command)`-hook.
* Refactored jruby-startup helper
* Cleanup API by moving deprecated methods to separate class
* Cleanup Core API - reduced to `cd`, `expand_path`, `setup_aruba` and use
  `expand_path` wherever possible ([#253])
* Better isolation for environment variable manipulation - really helpful from 1.0.0 on
* Move configuration files like `jruby.rb` to `aruba/config/`-directory
* Change default exit timeout to 15 seconds to work around long running processes on travis
* Use of instance variables like `@aruba_timeout_seconds` or
  `@aruba_io_wait_seconds` are deprecated.
  Use `Aruba.configure do |config| config.exit_timeout = 10` etc. for this.

## [0.7.4]
* Really Fixed post install message

## [0.7.3]
* Fixed post install message

## [0.7.2]

* Do not trigger Announcer API deprecation warning ([#277])

## [0.7.1]

* Do not break if `@interactive` is used

## [0.7.0]

* Introducing `root_directory` ([#232])
* Introducing fixtures directory ([#224])
* Make sure a file/directory does not exist + Cleanup named file/directory steps ([#234])
* Make matcher `have_permisions` public and add documentation ([#239])
* Added matcher for file content ([#238])
* Add rspec integrator ([#244])
* Deprecate `_file` and `_directory` in method names ([#243])
* Improve development environment ([#240])
* Cleanup process management ([#257])
* Make path content available through matchers and api metchods ([#250])
* Refactor announcer to support user defined announce channels (fixes [#267])
* `InProcess` requires that the working directory is determined on runtime not no loadtime

## [0.6.2]

* Fixed minor [#223])
* Added support for ruby 2.1.3 -- 2.1.5
* Added support for comparison to a fixture file

## [0.6.1]

* Added support for ruby 2.1.2
* Added support for `~` expansion
* Added support for `with_env`

## [0.6.0]

* Dropped support for ruby 1.8
* Added support for ruby 2.1.0 and 2.1.1
* Added rspec 3.0.0 support

## [0.5.4]

* Added support for piping in files ([#154], [maxmeyer], dg-vrnetze)
* Added cucumber steps for environment variables ([#156], dg-vrnetze)
* Added support for file mode ([#157], [maxmeyer], dg-vrnetze)

## [0.5.3]

* Fix for UTF-8 support ([#151], [mattwynne], [jarl-dk])
* Fix for open file leakage ([#150], [JonRowe])

## [0.5.2]

* Plugin API for greater speed. Test Ruby CLI programs in a single Ruby process ([#148], [aslakhellesoy])
* Fix memory leak when several commands are executed in a single run ([#144], [y-higuchi])

## [0.5.1]

* Individual timeout settings when running commands ([#124], [jarl-dk])
* Varous fixes for JRuby tests, should now work on more versions of JRuby

## [0.5.0]

* Add `#with_file_content` to the DSL ([#110], [argent-smith])
* Make JRuby performance tweaks optional ([#102], [taylor], [#125], [alindeman])
* Add `assert_partial_output_interactive` so you can peek at the output from a running process ([#104], [taylor])
* Add `assert_not_matching_output` ([#111], [argent-smith])
* Add `remove_dir` ([#121], [LTe])

## [0.4.11]

* Fix duplicated output ([#91], [robertwahler], [mattwynne])
* Fix Gemspec format ([#101], [mattwynne])

## [0.4.10]

* Fix broken JRuby file following rename of hook ([tdreyno])
* Add terminate method to API ([taylor])

## [0.4.9]

* Rename `before_run` hook to `before_cmd` ([mattwynne])
* Fix 1.8.7 compatibility ([#95], [davetron5000])

## [0.4.8]

* Add `before_run` hook ([mattwynne])
* Add JRuby performance tweaks ([#93], [myronmarston], [mattwynne])
* Invalid/Corrupt spec file for 0.4.7 - undefined method call for nil:Nilclass ([#47], [aslakhellesoy])

## [0.4.7]

* Remove rdiscount dependency. ([#85], [aslakhellesoy])
* Pin to ffi 1.0.9 since 1.0.10 is broken. ([aslakhellesoy])
* Added file size specific steps to the Aruba API. ([#89], [hectcastro])

## [0.4.6]

* Upgraded deps to latest gems. ([aslakhellesoy])
* Added Regexp support to `Aruba::Api#assert_no_partial_output`. ([aslakhellesoy])

## [0.4.5]

* Better assertion failure message when an exit code is not as expected.
  ([mattwynne])

## [0.4.4]

* Fix various bugs with interative processes. ([mattwynne])

## [0.4.3]

* Aruba reporting now creates an index file for reports, linking them all
  together. ([aslakhellesoy])

## [0.4.2]

* Appending to a file creates the parent directory if it doesn't exist.
  ([aslakhellesoy])

## [0.4.1]

* Move more logic into Aruba::Api ([aslakhellesoy])

## [0.4.0]

* New, awesome HTML reporting feature that captures everything that happens
  during a scenario. ([aslakhellesoy])
* ANSI escapes from output are stripped by default. Override this with the @ansi
  tag. ([aslakhellesoy])

## [0.3.7]

* Make `Aruba::Api#get_process` return the last executed process with passed cmd
  ([greyblake])
* Replace announce with puts to comply with cucumber 0.10.6 ([aslakhellesoy])
* Fix childprocess STDIN to be synchronous ([#40], [#71], [lithium3141])

## [0.3.6]

* Changed default value of `@aruba_timeout_seconds` from 1 to 3. ([aslakhellesoy])
* Separate hooks and steps to make it easier to build your own steps on top of
  Aruba's API ([msassak])
* `@no-clobber` to prevent cleanup before each scenario ([msassak])

## [0.3.5]

* Store processes in an array to ensure order of operations on Ruby 1.8.x
  ([#48] [msassak])

## [0.3.4]

* Use backticks (\`) instead of quotes (") to specify command line. Quote still
  works, but is deprecated. ([aeden], [aslakhellesoy])

## [0.3.3]

* Updated RSpec development requirement to 2.5 ([rspeicher], [msassak],
  [aslakhellesoy])
* Updated RubyGems dependency to 1.6.1 ([rspeicher])

## [0.3.2]

* Wrong number of args in the When I overwrite step ([aslakhellesoy])

## [0.3.1]

* Broken 0.3.0 release ([#43], [#44], [msassak])
* Quotes (") and newline (\n) in step arguments are no longer unescaped. ([aslakhellesoy])

## [0.3.0]

* Remove latency introduced in the 0.2.8 release ([#42], [msassak])
* New stepdef `Then /^the stdout should contain:$/ do |partial_output|` ([aslakhellesoy])
* Quotes (") and newline (\n) in step arguments no longer need to be backslash-escaped. ([aslakhellesoy])

## [0.2.8]

* Replaced `background_process` with `childprocess`, a cross-platform process control
  library. This will allow Aruba to run on Windows and JRuby in addition to \*nix
  MRI. ([#16], [#27], [#31], [msassak], [jarib], [mattwynne], [aknuds1])

## [0.2.7]

* Upgrade to Cucumber 0.10.0. ([aslakhellesoy])
* `require 'aruba'` does nothing - you have to `require 'aruba/cucumber'` now. This
  is to prevent bundler from loading it when we don't want to. ([aslakhellesoy])
* Outputting a lot of data causes process to time out ([#30], [msassak])

## [0.2.6]

* You can set `@aruba_timeout_seconds` in a Before hook to tell Aruba to wait
 for a process to complete. Default: 1 second. ([aslakhellesoy])
* Fixed small bug in `/^the stdout should contain exactly:$/` ([aslakhellesoy])

## [0.2.5]

* Added 'a file named "whatever" should (not) exist' ([rspeicher])
* Added 'a directory named "whatever" should (not) exist' ([rspeicher])
* Added /^the stderr should contain exactly:"$/ ([aslakhellesoy])
* Added /^the stdout should contain exactly:"$/ ([aslakhellesoy])
* Added /it should pass with exactly:/ ([aslakhellesoy])
* @announce, @announce-dir and @announce-cmd for interactive processes ([msassak])
* Add step defs for detecting output, stdout and stderr by process name ([msassak])
* Stop all processes before verifying filesystem changes to ensure async operations
  are complete ([#17], [msassak])
* Outputting large amounts of data causes run steps to hang ([#18], [msassak])

## [0.2.4]

* Added step definitions for removing files and checking presence of a single
  file. ([aslakhellesoy])

## [0.2.3]

* Directory should not exist gives false-positive ([#13], [#15], [nruth])
* Added step definitions for comparing file contents with regexps ([#9],
  [aslakhellesoy])
* Always put ./bin at the beginning of $PATH to make it easier to run own
  executables ([#7], [aslakhellesoy])
* Communication with interactive processes ([#4], [msassak])
* Remove hyphens separating stdout and stderr ([aknuds1])

## [0.2.2]

* Added a @bin tag that sets up './bin' first on the path ([aslakhellesoy])
* Richer API making aruba easier to use from Ruby code. (Mark Nijhof, [aslakhellesoy])
* No more support for RVM. Use rvm 1.9.2,1.8.7 exec cucumber .... instead. (Mark Nijhof, [aslakhellesoy])

## [0.2.1]

* Always compare with RSpec should =~ instead of should match. This gives a diff when there is no match. ([aslakhellesoy])

## [0.2.0]

* Added aruba.gemspec. ([dchelimsky])
* Several step definitions regarding output have changed. ([#1], [aslakhellesoy])

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

## [0.1.9]

* If the GOTGEMS environment variable is set, bundler won't run (faster). ([aslakhellesoy])

## [0.1.8]

* Use // instead of "" for "I should see matching" step. ([aslakhellesoy])
* Replace rvm gemset character '%' with '@' for rvm 0.1.24 ([#5], Ashley Moran)
* Support gem bundler, making it easier to specify gems. ([aslakhellesoy])

## [0.1.7]

* New @announce-stderr tag ([robertwahler])
* New "I should see matching" steps using Regexp ([robertwahler])

## [0.1.6]

* `When /^I successfully run "(.*)"$/` now prints the combined output if exit
  status is not 0. ([aslakhellesoy])
* Add bundle to list of common ruby scripts. ([aslakhellesoy])

## [0.1.5]

* Added ability to map rvm versions to a specific version with config/aruba-rvm.yml. ([aslakhellesoy])
* Check for presence of files. ([aslakhellesoy])
* Allow specification of rvm gemsets. ([aslakhellesoy])
* Detect ruby commands and use current ruby when rvm is not explicitly used. ([aslakhellesoy])
* Added support for rvm, making it possible to choose Ruby interpreter. ([aslakhellesoy])
* Added @announce-cmd, @announce-stdout and @announce tags, useful for seeing what's executed and outputted. ([aslakhellesoy])

## [0.1.4]

* New step definition for appending to a file ([aslakhellesoy])

## [0.1.3]

* New step definition for cd (change directory) ([aslakhellesoy])

## [0.1.2]

* Separated API from Cucumber step definitions, makes this usable without Cucumber. ([aslakhellesoy])

## [0.1.1]

* Better Regexp escaping ([dchelimsky])

## [0.1.0]

* First release ([dchelimsky] and [aslakhellesoy])

<!-- Contributors -->

[AdrieanKhisbe]:  https://github.com/AdrieanKhisbe
[LTe]:            https://github.com/LTe
[aeden]:          https://github.com/aeden
[aknuds1]:        https://github.com/aknuds1
[alindeman]:      https://github.com/alindeman
[aslakhellesoy]:  https://github.com/aslakhellesoy
[davetron5000]:   https://github.com/davetron5000
[dchelimsky]:     https://github.com/dchelimsky
[doudou]:         https://github.com/doudou
[e2]:             https://github.com/e2
[greyblake]:      https://github.com/greyblake
[hectcastro]:     https://github.com/hectcastro
[jarib]:          https://github.com/jarib
[jaysonesmith]:   https://github.com/jaysonesmith
[JonRowe]:        https://github.com/JonRowe
[lithium3141]:    https://github.com/lithium3141
[mattwynne]:      https://github.com/mattwynne
[maxmeyer]:       https://github.com/maxmeyer
[msassak]:        https://github.com/msassak
[mvz]:            https://github.com/mvz
[myronmarston]:   https://github.com/myronmarston
[njam]:           https://github.com/njam
[nruth]:          https://github.com/nruth
[olleolleolle]:   https://github.com/olleolleolle
[richardxia]:     https://github.com/richardxia
[robertwahler]:   https://github.com/robertwahler
[roschaefer]:     https://github.com/roschaefer
[rspeicher]:      https://github.com/rspeicher
[rubbish]:        https://github.com/rubbish
[scottj97]:       https://github.com/scottj97
[stamhankar999]:  https://github.com/stamhankar999
[taylor]:         https://github.com/taylor
[tdreyno]:        https://github.com/tdreyno
[xtrasimplicity]: https://github.com/xtrasimplicity

<!-- issues & pull requests -->

[#677]: https://github.com/cucumber/aruba/pull/677
[#676]: https://github.com/cucumber/aruba/pull/676
[#673]: https://github.com/cucumber/aruba/pull/673
[#668]: https://github.com/cucumber/aruba/pull/668
[#664]: https://github.com/cucumber/aruba/pull/664
[#658]: https://github.com/cucumber/aruba/pull/658
[#650]: https://github.com/cucumber/aruba/pull/650
[#647]: https://github.com/cucumber/aruba/pull/647
[#645]: https://github.com/cucumber/aruba/pull/645
[#642]: https://github.com/cucumber/aruba/pull/642
[#639]: https://github.com/cucumber/aruba/pull/639
[#638]: https://github.com/cucumber/aruba/pull/638
[#622]: https://github.com/cucumber/aruba/pull/622
[#621]: https://github.com/cucumber/aruba/pull/621
[#620]: https://github.com/cucumber/aruba/pull/620
[#612]: https://github.com/cucumber/aruba/pull/612
[#611]: https://github.com/cucumber/aruba/pull/611
[#610]: https://github.com/cucumber/aruba/pull/610
[#604]: https://github.com/cucumber/aruba/pull/604
[#603]: https://github.com/cucumber/aruba/pull/603
[#602]: https://github.com/cucumber/aruba/pull/602
[#601]: https://github.com/cucumber/aruba/pull/601
[#597]: https://github.com/cucumber/aruba/pull/597
[#591]: https://github.com/cucumber/aruba/pull/591
[#588]: https://github.com/cucumber/aruba/pull/588
[#585]: https://github.com/cucumber/aruba/pull/585
[#582]: https://github.com/cucumber/aruba/pull/582
[#572]: https://github.com/cucumber/aruba/pull/572
[#571]: https://github.com/cucumber/aruba/pull/571
[#561]: https://github.com/cucumber/aruba/pull/561
[#557]: https://github.com/cucumber/aruba/pull/557
[#551]: https://github.com/cucumber/aruba/pull/551
[#548]: https://github.com/cucumber/aruba/pull/548
[#546]: https://github.com/cucumber/aruba/pull/546
[#544]: https://github.com/cucumber/aruba/pull/544
[#543]: https://github.com/cucumber/aruba/pull/543
[#542]: https://github.com/cucumber/aruba/pull/542
[#541]: https://github.com/cucumber/aruba/pull/541
[#540]: https://github.com/cucumber/aruba/pull/540
[#537]: https://github.com/cucumber/aruba/pull/537
[#536]: https://github.com/cucumber/aruba/pull/536
[#535]: https://github.com/cucumber/aruba/pull/535
[#532]: https://github.com/cucumber/aruba/pull/532
[#530]: https://github.com/cucumber/aruba/pull/530
[#529]: https://github.com/cucumber/aruba/pull/529
[#528]: https://github.com/cucumber/aruba/pull/528
[#523]: https://github.com/cucumber/aruba/pull/523
[#522]: https://github.com/cucumber/aruba/pull/522
[#520]: https://github.com/cucumber/aruba/pull/520
[#517]: https://github.com/cucumber/aruba/pull/517
[#516]: https://github.com/cucumber/aruba/pull/516
[#515]: https://github.com/cucumber/aruba/pull/515
[#514]: https://github.com/cucumber/aruba/pull/514
[#512]: https://github.com/cucumber/aruba/pull/512
[#511]: https://github.com/cucumber/aruba/pull/511
[#510]: https://github.com/cucumber/aruba/pull/510
[#509]: https://github.com/cucumber/aruba/pull/509
[#508]: https://github.com/cucumber/aruba/pull/508
[#507]: https://github.com/cucumber/aruba/pull/507
[#504]: https://github.com/cucumber/aruba/pull/504
[#498]: https://github.com/cucumber/aruba/pull/498
[#497]: https://github.com/cucumber/aruba/pull/497
[#495]: https://github.com/cucumber/aruba/pull/495
[#494]: https://github.com/cucumber/aruba/pull/494
[#493]: https://github.com/cucumber/aruba/pull/493
[#491]: https://github.com/cucumber/aruba/pull/491
[#490]: https://github.com/cucumber/aruba/pull/490
[#489]: https://github.com/cucumber/aruba/pull/489
[#488]: https://github.com/cucumber/aruba/pull/488
[#487]: https://github.com/cucumber/aruba/pull/487
[#486]: https://github.com/cucumber/aruba/pull/486
[#483]: https://github.com/cucumber/aruba/pull/483
[#482]: https://github.com/cucumber/aruba/pull/482
[#481]: https://github.com/cucumber/aruba/pull/481
[#476]: https://github.com/cucumber/aruba/pull/476
[#475]: https://github.com/cucumber/aruba/pull/475
[#471]: https://github.com/cucumber/aruba/pull/471
[#466]: https://github.com/cucumber/aruba/pull/466
[#464]: https://github.com/cucumber/aruba/pull/464
[#462]: https://github.com/cucumber/aruba/pull/462
[#461]: https://github.com/cucumber/aruba/pull/461
[#460]: https://github.com/cucumber/aruba/pull/460
[#459]: https://github.com/cucumber/aruba/pull/459
[#457]: https://github.com/cucumber/aruba/pull/457
[#456]: https://github.com/cucumber/aruba/pull/456
[#454]: https://github.com/cucumber/aruba/pull/454
[#452]: https://github.com/cucumber/aruba/pull/452
[#451]: https://github.com/cucumber/aruba/issues/451
[#449]: https://github.com/cucumber/aruba/issues/449
[#447]: https://github.com/cucumber/aruba/issues/447
[#445]: https://github.com/cucumber/aruba/issues/445
[#444]: https://github.com/cucumber/aruba/issues/444
[#442]: https://github.com/cucumber/aruba/issues/442
[#439]: https://github.com/cucumber/aruba/issues/439
[#438]: https://github.com/cucumber/aruba/issues/438
[#436]: https://github.com/cucumber/aruba/issues/436
[#433]: https://github.com/cucumber/aruba/issues/433
[#427]: https://github.com/cucumber/aruba/issues/427
[#422]: https://github.com/cucumber/aruba/issues/422
[#398]: https://github.com/cucumber/aruba/issues/398
[#390]: https://github.com/cucumber/aruba/issues/390
[#389]: https://github.com/cucumber/aruba/issues/389
[#388]: https://github.com/cucumber/aruba/issues/388
[#387]: https://github.com/cucumber/aruba/issues/387
[#385]: https://github.com/cucumber/aruba/issues/385
[#382]: https://github.com/cucumber/aruba/issues/382
[#376]: https://github.com/cucumber/aruba/issues/376
[#375]: https://github.com/cucumber/aruba/issues/375
[#372]: https://github.com/cucumber/aruba/issues/372
[#366]: https://github.com/cucumber/aruba/issues/366
[#359]: https://github.com/cucumber/aruba/issues/359
[#358]: https://github.com/cucumber/aruba/issues/358
[#357]: https://github.com/cucumber/aruba/issues/357
[#353]: https://github.com/cucumber/aruba/issues/353
[#352]: https://github.com/cucumber/aruba/issues/352
[#349]: https://github.com/cucumber/aruba/issues/349
[#347]: https://github.com/cucumber/aruba/issues/347
[#342]: https://github.com/cucumber/aruba/issues/342
[#341]: https://github.com/cucumber/aruba/issues/341
[#339]: https://github.com/cucumber/aruba/issues/339
[#338]: https://github.com/cucumber/aruba/issues/338
[#336]: https://github.com/cucumber/aruba/issues/336
[#335]: https://github.com/cucumber/aruba/issues/335
[#323]: https://github.com/cucumber/aruba/issues/323
[#322]: https://github.com/cucumber/aruba/issues/322
[#321]: https://github.com/cucumber/aruba/issues/321
[#320]: https://github.com/cucumber/aruba/issues/320
[#314]: https://github.com/cucumber/aruba/issues/314
[#309]: https://github.com/cucumber/aruba/issues/309
[#308]: https://github.com/cucumber/aruba/issues/308
[#306]: https://github.com/cucumber/aruba/issues/306
[#305]: https://github.com/cucumber/aruba/issues/305
[#304]: https://github.com/cucumber/aruba/issues/304
[#302]: https://github.com/cucumber/aruba/issues/302
[#294]: https://github.com/cucumber/aruba/issues/294
[#292]: https://github.com/cucumber/aruba/issues/292
[#287]: https://github.com/cucumber/aruba/issues/287
[#286]: https://github.com/cucumber/aruba/issues/286
[#282]: https://github.com/cucumber/aruba/issues/282
[#279]: https://github.com/cucumber/aruba/issues/279
[#277]: https://github.com/cucumber/aruba/issues/277
[#271]: https://github.com/cucumber/aruba/issues/271
[#268]: https://github.com/cucumber/aruba/issues/268
[#267]: https://github.com/cucumber/aruba/issues/267
[#260]: https://github.com/cucumber/aruba/issues/260
[#257]: https://github.com/cucumber/aruba/issues/257
[#253]: https://github.com/cucumber/aruba/issues/253
[#250]: https://github.com/cucumber/aruba/issues/250
[#244]: https://github.com/cucumber/aruba/issues/244
[#243]: https://github.com/cucumber/aruba/issues/243
[#240]: https://github.com/cucumber/aruba/issues/240
[#239]: https://github.com/cucumber/aruba/issues/239
[#238]: https://github.com/cucumber/aruba/issues/238
[#234]: https://github.com/cucumber/aruba/issues/234
[#232]: https://github.com/cucumber/aruba/issues/232
[#224]: https://github.com/cucumber/aruba/issues/224
[#223]: https://github.com/cucumber/aruba/issues/223
[#157]: https://github.com/cucumber/aruba/issues/157
[#156]: https://github.com/cucumber/aruba/issues/156
[#154]: https://github.com/cucumber/aruba/issues/154
[#151]: https://github.com/cucumber/aruba/issues/151
[#150]: https://github.com/cucumber/aruba/issues/150
[#148]: https://github.com/cucumber/aruba/issues/148
[#144]: https://github.com/cucumber/aruba/issues/144
[#125]: https://github.com/cucumber/aruba/issues/125
[#124]: https://github.com/cucumber/aruba/issues/124
[#121]: https://github.com/cucumber/aruba/issues/121
[#111]: https://github.com/cucumber/aruba/issues/111
[#110]: https://github.com/cucumber/aruba/issues/110
[#104]: https://github.com/cucumber/aruba/issues/104
[#102]: https://github.com/cucumber/aruba/issues/102
[#101]: https://github.com/cucumber/aruba/issues/101
[#95]:  https://github.com/cucumber/aruba/issues/95
[#93]:  https://github.com/cucumber/aruba/issues/93
[#91]:  https://github.com/cucumber/aruba/issues/91
[#89]:  https://github.com/cucumber/aruba/issues/89
[#85]:  https://github.com/cucumber/aruba/issues/85
[#71]:  https://github.com/cucumber/aruba/issues/71
[#48]:  https://github.com/cucumber/aruba/issues/48
[#47]:  https://github.com/cucumber/aruba/issues/47
[#44]:  https://github.com/cucumber/aruba/issues/44
[#43]:  https://github.com/cucumber/aruba/issues/43
[#42]:  https://github.com/cucumber/aruba/issues/42
[#40]:  https://github.com/cucumber/aruba/issues/40
[#31]:  https://github.com/cucumber/aruba/issues/31
[#30]:  https://github.com/cucumber/aruba/issues/30
[#27]:  https://github.com/cucumber/aruba/issues/27
[#18]:  https://github.com/cucumber/aruba/issues/18
[#17]:  https://github.com/cucumber/aruba/issues/17
[#16]:  https://github.com/cucumber/aruba/issues/16
[#15]:  https://github.com/cucumber/aruba/issues/15
[#13]:  https://github.com/cucumber/aruba/issues/13
[#9]:   https://github.com/cucumber/aruba/issues/9
[#7]:   https://github.com/cucumber/aruba/issues/7
[#5]:   https://github.com/cucumber/aruba/issues/5
[#4]:   https://github.com/cucumber/aruba/issues/4
[#1]:   https://github.com/cucumber/aruba/issues/1

[cucumber/cucumber#521]: https://github.com/cucumber/cucumber/issues/521
[jruby/jruby#316]:       https://github.com/jruby/jruby/issues/316

<!-- Releases -->

[0.14.14]:       https://github.com/cucumber/aruba/compare/v0.14.13...v0.14.14
[0.14.13]:       https://github.com/cucumber/aruba/compare/v0.14.12...v0.14.13
[0.14.12]:       https://github.com/cucumber/aruba/compare/v0.14.11...v0.14.12
[0.14.11]:       https://github.com/cucumber/aruba/compare/v0.14.10...v0.14.11
[0.14.10]:       https://github.com/cucumber/aruba/compare/v0.14.9...v0.14.10
[0.14.9]:        https://github.com/cucumber/aruba/compare/v0.14.8...v0.14.9
[0.14.8]:        https://github.com/cucumber/aruba/compare/v0.14.7...v0.14.8
[0.14.7]:        https://github.com/cucumber/aruba/compare/v0.14.6...v0.14.7
[0.14.6]:        https://github.com/cucumber/aruba/compare/v0.14.5...v0.14.6
[0.14.5]:        https://github.com/cucumber/aruba/compare/v0.14.4...v0.14.5
[0.14.4]:        https://github.com/cucumber/aruba/compare/v0.14.3...v0.14.4
[0.14.3]:        https://github.com/cucumber/aruba/compare/v0.14.2...v0.14.3
[0.14.2]:        https://github.com/cucumber/aruba/compare/v0.14.1...v0.14.2
[0.14.1]:        https://github.com/cucumber/aruba/compare/v0.14.0...v0.14.1
[0.14.0]:        https://github.com/cucumber/aruba/compare/v0.13.0...v0.14.0
[0.13.0]:        https://github.com/cucumber/aruba/compare/v0.12.0...v0.13.0
[0.12.0]:        https://github.com/cucumber/aruba/compare/v0.11.2...v0.12.0
[0.11.2]:        https://github.com/cucumber/aruba/compare/v0.11.1...v0.11.2
[0.11.1]:        https://github.com/cucumber/aruba/compare/v0.11.0...v0.11.1
[0.11.0]:        https://github.com/cucumber/aruba/compare/v0.11.0.pre4...v0.11.0
[0.11.0.pre4]:   https://github.com/cucumber/aruba/compare/v0.11.0.pre3...v0.11.0.pre4
[0.11.0.pre3]:   https://github.com/cucumber/aruba/compare/v0.11.0.pre2...v0.11.0.pre3
[0.11.0.pre2]:   https://github.com/cucumber/aruba/compare/v0.11.0.pre...v0.11.0.pre2
[0.11.0.pre]:    https://github.com/cucumber/aruba/compare/v0.10.2...v0.11.0.pre
[0.10.2]:        https://github.com/cucumber/aruba/compare/v0.10.1...v0.10.2
[0.10.1]:        https://github.com/cucumber/aruba/compare/v0.10.0...v0.10.1
[0.10.0]:        https://github.com/cucumber/aruba/compare/v0.10.0.pre2...v0.10.0
[0.10.0.pre2]:   https://github.com/cucumber/aruba/compare/v0.10.0.pre...v0.10.0.pre2
[0.10.0.pre]:    https://github.com/cucumber/aruba/compare/v0.9.0...v0.10.0
[0.9.0]:         https://github.com/cucumber/aruba/compare/v0.9.0.pre2...v0.9.0
[0.9.0.pre2]:    https://github.com/cucumber/aruba/compare/v0.9.0.pre...v0.9.0.pre2
[0.9.0.pre]:     https://github.com/cucumber/aruba/compare/v0.8.1...v0.9.0.pre
[0.8.1]:         https://github.com/cucumber/aruba/compare/v0.8.0...v0.8.1
[0.8.0]:         https://github.com/cucumber/aruba/compare/v0.8.0.pre3...v0.8.0
[0.8.0.pre3]:    https://github.com/cucumber/aruba/compare/v0.8.0.pre2...v0.8.0.pre3
[0.8.0.pre2]:    https://github.com/cucumber/aruba/compare/v0.8.0...v0.8.0.pre2
[0.8.0.pre]:     https://github.com/cucumber/aruba/compare/v0.7.4...v0.8.0.pre
[0.7.4]:         https://github.com/cucumber/aruba/compare/v0.7.2...v0.7.4
[0.7.3]:         https://github.com/cucumber/aruba/compare/v0.7.2...v0.7.3
[0.7.2]:         https://github.com/cucumber/aruba/compare/v0.7.1...v0.7.2
[0.7.1]:         https://github.com/cucumber/aruba/compare/v0.7.0...v0.7.1
[0.7.0]:         https://github.com/cucumber/aruba/compare/v0.6.2...v0.7.0
[0.6.2]:         https://github.com/cucumber/aruba/compare/v0.6.1...v0.6.2
[0.6.1]:         https://github.com/cucumber/aruba/compare/v0.6.0...v0.6.1
[0.6.0]:         https://github.com/cucumber/aruba/compare/v0.5.4...v0.6.0
[0.5.4]:         https://github.com/cucumber/aruba/compare/v0.5.3...v0.5.4
[0.5.3]:         https://github.com/cucumber/aruba/compare/v0.5.2...v0.5.3
[0.5.2]:         https://github.com/cucumber/aruba/compare/v0.5.1...v0.5.2
[0.5.1]:         https://github.com/cucumber/aruba/compare/v0.5.0...v0.5.1
[0.5.0]:         https://github.com/cucumber/aruba/compare/v0.4.10...v0.5.0
[0.4.11]:        https://github.com/cucumber/aruba/compare/v0.4.10...v0.4.11
[0.4.10]:        https://github.com/cucumber/aruba/compare/v0.4.9...v0.4.10
[0.4.9]:         https://github.com/cucumber/aruba/compare/v0.4.8...v0.4.9
[0.4.8]:         https://github.com/cucumber/aruba/compare/v0.4.7...v0.4.8
[0.4.7]:         https://github.com/cucumber/aruba/compare/v0.4.6...v0.4.7
[0.4.6]:         https://github.com/cucumber/aruba/compare/v0.4.5...v0.4.6
[0.4.5]:         https://github.com/cucumber/aruba/compare/v0.4.4...v0.4.5
[0.4.4]:         https://github.com/cucumber/aruba/compare/v0.4.3...v0.4.4
[0.4.3]:         https://github.com/cucumber/aruba/compare/v0.4.2...v0.4.3
[0.4.2]:         https://github.com/cucumber/aruba/compare/v0.4.1...v0.4.2
[0.4.1]:         https://github.com/cucumber/aruba/compare/v0.4.0...v0.4.1
[0.4.0]:         https://github.com/cucumber/aruba/compare/v0.3.7...v0.4.0
[0.3.7]:         https://github.com/cucumber/aruba/compare/v0.3.6...v0.3.7
[0.3.6]:         https://github.com/cucumber/aruba/compare/v0.3.5...v0.3.6
[0.3.5]:         https://github.com/cucumber/aruba/compare/v0.3.4...v0.3.5
[0.3.4]:         https://github.com/cucumber/aruba/compare/v0.3.3...v0.3.4
[0.3.3]:         https://github.com/cucumber/aruba/compare/v0.3.2...v0.3.3
[0.3.2]:         https://github.com/cucumber/aruba/compare/v0.3.1...v0.3.2
[0.3.1]:         https://github.com/cucumber/aruba/compare/v0.3.0...v0.3.1
[0.3.0]:         https://github.com/cucumber/aruba/compare/v0.2.8...v0.3.0
[0.2.8]:         https://github.com/cucumber/aruba/compare/v0.2.7...v0.2.8
[0.2.7]:         https://github.com/cucumber/aruba/compare/v0.2.6...v0.2.7
[0.2.6]:         https://github.com/cucumber/aruba/compare/v0.2.5...v0.2.6
[0.2.5]:         https://github.com/cucumber/aruba/compare/v0.2.4...v0.2.5
[0.2.4]:         https://github.com/cucumber/aruba/compare/v0.2.3...v0.2.4
[0.2.3]:         https://github.com/cucumber/aruba/compare/v0.2.2...v0.2.3
[0.2.2]:         https://github.com/cucumber/aruba/compare/v0.2.1...v0.2.2
[0.2.1]:         https://github.com/cucumber/aruba/compare/v0.2.0...v0.2.1
[0.2.0]:         https://github.com/cucumber/aruba/compare/v0.1.9...v0.2.0
[0.1.9]:         https://github.com/cucumber/aruba/compare/v0.1.8...v0.1.9
[0.1.8]:         https://github.com/cucumber/aruba/compare/v0.1.7...v0.1.8
[0.1.7]:         https://github.com/cucumber/aruba/compare/v0.1.6...v0.1.7
[0.1.6]:         https://github.com/cucumber/aruba/compare/v0.1.5...v0.1.6
[0.1.5]:         https://github.com/cucumber/aruba/compare/v0.1.4...v0.1.5
[0.1.4]:         https://github.com/cucumber/aruba/compare/v0.1.3...v0.1.4
[0.1.3]:         https://github.com/cucumber/aruba/compare/v0.1.2...v0.1.3
[0.1.2]:         https://github.com/cucumber/aruba/compare/v0.1.1...v0.1.2
[0.1.1]:         https://github.com/cucumber/aruba/compare/v0.1.0...v0.1.1
[0.1.0]:         https://github.com/cucumber/aruba/compare/ed6a175d23aaff62dbf355706996f276f304ae8b...v0.1.1

<!-- Other links -->

[1]:  http://semver.org
[2]:  http://keepachangelog.com
[3]:  https://github.com/cucumber/aruba/blob/master/CONTRIBUTING.md
