## [v0.5.1](https://github.com/cucumber/aruba/compare/v0.5..v0.5.1)
* Individual timeout settings when running commands (#124 Jarl Friis)
* Varous fixes for JRuby tests, should now work on more versions of JRuby

## [v0.5](https://github.com/cucumber/aruba/compare/v0.4.10..v0.5)
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
