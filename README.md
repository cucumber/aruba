[![Gem Version](https://badge.fury.io/rb/aruba.svg)](http://badge.fury.io/rb/aruba)
[![Dependency Status](https://gemnasium.com/cucumber/aruba.svg)](https://gemnasium.com/cucumber/aruba)
[![Code Climate](https://codeclimate.com/github/cucumber/aruba.svg)](https://codeclimate.com/github/cucumber/aruba)
[![Join the chat at https://gitter.im/cucumber/aruba](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/cucumber/aruba?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

**This is the [latest](https://github.com/cucumber/aruba/blob/master/README.md) version of our README.md. If you want to see the one of the last released version of "aruba", please have a look at this [one](https://github.com/cucumber/aruba/blob/still/README.md).**

`aruba` is an extension for popular TDD and BDD frameworks like "Cucumber", "RSpec" and "Minitest" to make testing of commandline applications meaningful, easy and fun.

Your benefits:

* Test any command line application implemented in any [programming
  language](https://github.com/cucumber/aruba/tree/master/features/getting_started/supported_programming_languages.feature) -
  e.g. Bash, Python, Ruby, Java, ...
* Manipulate the file system and the process environment with helpers working similar like tools you may know from your shell
* No worries about leaking state: The file system and the process environment will be reset between tests
* Support by a helpful and welcoming community &ndash; see our [Code of Conduct](https://github.com/cucumber/cucumber/blob/master/CODE_OF_CONDUCT.md)
* The [documentation](https://github.com/cucumber/aruba/tree/master/features/) is our contract with you. You can expect `aruba` to work as documented

Our Vision:

* Help our users to build better command line applications written in any programming language
* Make creating documentation for command line simple and fun
* Support the cucumber community in its effort to create a specification for all official cucumber implementations

Our Focus:
* Test the user-interaction with the commands at runtime &ndash; this excludes the process of installation/deployment of commands like installing Rubygems with `gem install <your-gem>`.


<table>
  <thead>
    <tr>
      <th colspan="3">
        Build status
      </th>
    </tr>
    <tr>
      <th>
        Version
      </th>
      <th>
        Linux / OS X
      </th>
      <th>
        Windows
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        master
      </td>
      <td>
        [![Build Status](https://travis-ci.org/cucumber/aruba.svg?branch=master)](https://travis-ci.org/cucumber/aruba)
      </td>
      <td>
        [![Build status](https://ci.appveyor.com/api/projects/status/jfo2tkqhnrqqcivl?svg=true)](https://ci.appveyor.com/project/cucumberbdd/aruba/branch/master)
      </td>
    </tr>
    <tr>
      <td>
        still
      </td>
      <td>
        [![Build Status](https://travis-ci.org/cucumber/aruba.svg?branch=still)](https://travis-ci.org/cucumber/aruba)
      </td>
      <td>
        [![Build status](https://ci.appveyor.com/api/projects/status/jfo2tkqhnrqqcivl?svg=true)](https://ci.appveyor.com/project/cucumberbdd/aruba/branch/still)
      </td>
    </tr>
  </tbody>
<table>


## Install

Add this line to your application's `Gemfile`:

    gem 'aruba'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aruba

### Release Policy

We try to be compliant to [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html).

### Supported ruby versions

For an up to date list of all supported ruby versions, please see our [`.travis.yml`](https://github.com/cucumber/aruba/blob/master/.travis.yml). We only test against the latest version of a version branch - most times.

## Usage

Please also see this
[feature test](https://github.com/cucumber/aruba/tree/master/features/getting_started/supported_testing_frameworks.feature)
for the most up to date documentation.

### Initialize your project with "aruba"

There's an initializer to make it easier for you to getting started. If you
prefer to setup `aruba` yourself, please move on to the next section.

1. Go to your project's directory

2. Make sure, it's under version control and all changes are committed to your
   version control repository

3. Run one of the following commands depending on the tools you use to test your project.

   This assumes, that you use either `rspec`, `cucumber-ruby` or `minitest` to
   write the tests for your project. Besides that, your tool can be implemented
   in any programming language you like.

   ~~~bash
   aruba init --test-framework rspec
   aruba init --test-framework cucumber
   aruba init --test-framework minitest
   ~~~

### Cucumber

1. Create a file named "features/support/env.rb" with:

   ~~~ruby
   require 'aruba/cucumber'
   ~~~

2. Create a file named "features/use_aruba_with_cucumber.feature" with:

   ~~~ruby
   Feature: Cucumber
     Scenario: First Run
       Given a file named "file.txt" with:
       """
       Hello World
       """
       Then the file "file.txt" should contain:
       """
       Hello World
       """
   ~~~

3. Run `cucumber`

### RSpec

1. Create a file named "spec/support/aruba.rb" with:

   ~~~ruby
   require 'aruba/rspec'
   ~~~

2. Create a file named "spec/spec_helper.rb" with:

   ~~~ruby
   $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

   ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
   ~~~

3. Create a file named "spec/use_aruba_with_rspec_spec.rb" with:

   ~~~ruby
   require 'spec_helper'

   RSpec.describe 'First Run', :type => :aruba do
     let(:file) { 'file.txt' }
     let(:content) { 'Hello World' }

     before(:each) { write_file file, content }

     it { expect(read(file)).to eq [content] }
   end
   ~~~

4. Run `rspec`

### Minitest

1. Add a file named "test/support/aruba.rb" with:

   ~~~ ruby
   require 'aruba/api'
   ~~~

2. Add a file named "test/test_helper.rb" with:

   ~~~ruby
   $LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

   ::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }
   ~~~

3. Add a file named "test/use_aruba_with_minitest.rb" with:

   ~~~ruby
   $LOAD_PATH.unshift File.expand_path('../test', __FILE__)

   require 'test_helper'
   require 'minitest/autorun'

   class FirstRun < Minitest::Test
     include Aruba::Api

     def setup
       aruba_setup
     end

     def getting_started_with_aruba
       file = 'file.txt'
       content = 'Hello World' 

       write_file file, content
       read(file).must_equal [content]
     end
   end
   ~~~

4. Run your tests

   `ruby -Ilib:test test/use_aruba_with_minitest.rb`

## Documentation

### User Documentation

If you're interested in our steps and API, please browse our [feature
files](https://github.com/cucumber/aruba/tree/master/features/). You can find a
lot of examples there. A good starting point are [Getting
Started](https://github.com/cucumber/aruba/tree/master/features/getting_started/)
and [Step
Overview](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/overview.feature).
A more or less full list of our steps can be found
[here](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/). Our API
is documentated
[here](https://github.com/cucumber/aruba/tree/master/features/api/) and some
more information about how to configure `aruba`, can be found
[here](https://github.com/cucumber/aruba/tree/master/features/configuration/).
The "RSpec" matchers provided by `aruba`, are documented
[here](https://github.com/cucumber/aruba/tree/master/features/matchers/) you can use them with any testing framework we
support.

You can find our documentation on
[Relish](http://www.relishapp.com/cucumber/aruba/docs) as well. Unfortunately
"Relish" does not like the way we structured our feature tests. So this
documentation found there may be not complete.

**Table of Contents**

There are some things which are still undocumented. We would like to encourage
you to add documentation for those and send us a PR.

* [Getting Started](https://github.com/cucumber/aruba/tree/master/features/getting_started)
  * [Cleanup Working Directory](https://github.com/cucumber/aruba/tree/master/features/getting_started/cleanup.feature)
  * [Install library](https://github.com/cucumber/aruba/tree/master/features/getting_started/install.feature)
  * [Supported Testing Frameworks](https://github.com/cucumber/aruba/tree/master/features/getting_started/supported_testing_frameworks.feature)
  * [Writing Good Tests.feature](https://github.com/cucumber/aruba/tree/master/features/getting_started/writing_good_feature_tests.feature)
  * [Run Commands](https://github.com/cucumber/aruba/tree/master/features/getting_started/run_commands.feature)

* [Use aruba command](https://github.com/cucumber/aruba/tree/master/features/cli)
  * [Start aruba console to try API](https://github.com/cucumber/aruba/tree/master/features/cli/console.feature)
  * [Initialize project with "aruba"](https://github.com/cucumber/aruba/tree/master/features/cli/init.feature)

* [Use with test frameworks](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks)
  * [RSpec](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/rspec)
    * [Setup](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/rspec/setup.feature)
    * [Hooks](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/rspec/hooks)
      * [After Command](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/rspec/hooks/after/command.feature)
      * [Before Command](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/rspec/hooks/before/command.feature)

  * [Cucumber](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber)
    * [Setup](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/setup.feature)
    * [Get overview over steps](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/overview.feature)
    * [Announce Information](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/announce.feature)
    * [Step definitions](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command)
      * [Command](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command)
        * [debug](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command/debug.feature)
        * [exit statuses](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command/exit_statuses.feature)
        * [in process](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command/in_process.feature)
        * [interactive](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command/interactive.feature)
        * [output](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command/output.feature)
        * [run](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command/run.feature)
        * [send signal](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command/send_signal.feature)
        * [shell](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command/shell.feature)
        * [stderr](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command/stderr.feature)
        * [stdout](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command/stdout.feature)
        * [stop](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/command/stop.feature)
      * [Environment](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/environment)
        * [append environment variable](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/environment/append_environment_variable.feature)
        * [home variable](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/environment/home_variable.feature)
        * [prepend environment variable](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/environment/prepend_environment_variable.feature)
        * [set environment variable](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/environment/set_environment_variable.feature)
      * [filesystem](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem)
        * [append to file](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/append_to_file.feature)
        * [cd to directory](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/cd_to_directory.feature)
        * [check file content](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/check_file_content.feature)
        * [check permissions of file](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/check_permissions_of_file.feature)
        * [compare files](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/compare_files.feature)
        * [copy](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/copy.feature)
        * [create directory](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/create_directory.feature)
        * [create file](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/create_file.feature)
        * [existence of directory](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/existence_of_directory.feature)
        * [existence of file](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/existence_of_file.feature)
        * [file content](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/file_content.feature)
        * [fixtures](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/fixtures.feature)
        * [move](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/move.feature)
        * [non existence of directory](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/non_existence_of_directory.feature)
        * [non existence of file](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/non_existence_of_file.feature)
        * [overwrite file](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/overwrite_file.feature)
        * [remove directory](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/remove_directory.feature)
        * [remove file](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/remove_file.feature)
        * [use fixture](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/steps/filesystem/use_fixture.feature)
    * [Hooks](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/hooks)
      * [After Command](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/hooks/after/command.feature)
      * [Before Command](https://github.com/cucumber/aruba/tree/master/features/testing_frameworks/cucumber/hooks/before/command.feature)

* [Configuration](https://github.com/cucumber/aruba/tree/master/features/configuration)
  * [activate announcer on command failure](https://github.com/cucumber/aruba/tree/master/features/configuration/activate_announcer_on_command_failure.feature)
  * [command runtime environment](https://github.com/cucumber/aruba/tree/master/features/configuration/command_runtime_environment.feature)
  * [console history file](https://github.com/cucumber/aruba/tree/master/features/configuration/console_history_file.feature)
  * [exit timeout](https://github.com/cucumber/aruba/tree/master/features/configuration/exit_timeout.feature)
  * [fixtures directories](https://github.com/cucumber/aruba/tree/master/features/configuration/fixtures_directories.feature)
  * [fixtures path prefix](https://github.com/cucumber/aruba/tree/master/features/configuration/fixtures_path_prefix.feature)
  * [home directory](https://github.com/cucumber/aruba/tree/master/features/configuration/home_directory.feature)
  * [io timeout](https://github.com/cucumber/aruba/tree/master/features/configuration/io_timeout.feature)
  * [keep ansi](https://github.com/cucumber/aruba/tree/master/features/configuration/keep_ansi.feature)
  * [log level](https://github.com/cucumber/aruba/tree/master/features/configuration/log_level.feature)
  * [physical block size](https://github.com/cucumber/aruba/tree/master/features/configuration/physical_block_size.feature)
  * [remove ansi escape sequences](https://github.com/cucumber/aruba/tree/master/features/configuration/remove_ansi_escape_sequences.feature)
  * [root directory](https://github.com/cucumber/aruba/tree/master/features/configuration/root_directory.feature)
  * [startup wait time](https://github.com/cucumber/aruba/tree/master/features/configuration/startup_wait_time.feature)
  * [usage](https://github.com/cucumber/aruba/tree/master/features/configuration/usage.feature)
  * [working directory](https://github.com/cucumber/aruba/tree/master/features/configuration/working_directory.feature)

* [Development of Aruba](https://github.com/cucumber/aruba/tree/master/features/development)
  * [bootstrap aruba](https://github.com/cucumber/aruba/tree/master/features/development/bootstrap-aruba.feature)
  * [build aruba](https://github.com/cucumber/aruba/tree/master/features/development/build-aruba.feature)
  * [build docker image](https://github.com/cucumber/aruba/tree/master/features/development/build-docker-image.feature)
  * [install gem](https://github.com/cucumber/aruba/tree/master/features/development/install-gem.feature)
  * [lint ruby sources](https://github.com/cucumber/aruba/tree/master/features/development/lint-ruby-sources.feature)
  * [lint travisjconfiguration](https://github.com/cucumber/aruba/tree/master/features/development/lint-travis-configuration.feature)
  * [lint used licenses of rubygems](https://github.com/cucumber/aruba/tree/master/features/development/lint-used-licenses-of-rubygems.feature)
  * [release gem](https://github.com/cucumber/aruba/tree/master/features/development/release-gem.feature)
  * [run aruba console](https://github.com/cucumber/aruba/tree/master/features/development/run-aruba-console.feature)
  * [run docker container](https://github.com/cucumber/aruba/tree/master/features/development/run-docker-container.feature)
  * [run test suite](https://github.com/cucumber/aruba/tree/master/features/development/run-test-suite.feature)

* [Matchers](https://github.com/cucumber/aruba/tree/master/features/matchers)
  * [collection](https://github.com/cucumber/aruba/tree/master/features/matchers/collection)
    * [include an object](https://github.com/cucumber/aruba/tree/master/features/matchers/collection/include_an_object.feature)
  * [command](https://github.com/cucumber/aruba/tree/master/features/matchers/command)
  * [directory](https://github.com/cucumber/aruba/tree/master/features/matchers/directory)
    * [have sub directory](https://github.com/cucumber/aruba/tree/master/features/matchers/directory/have_sub_directory.feature)
  * [file](https://github.com/cucumber/aruba/tree/master/features/matchers/file)
    * [be a command found in path](https://github.com/cucumber/aruba/tree/master/features/matchers/file/be_a_command_found_in_path.feature)
    * [be existing executable](https://github.com/cucumber/aruba/tree/master/features/matchers/file/be_existing_executable.feature)
    * [be existing file](https://github.com/cucumber/aruba/tree/master/features/matchers/file/be_existing_file.feature)
    * [have file content](https://github.com/cucumber/aruba/tree/master/features/matchers/file/have_file_content.feature)
    * [have file size](https://github.com/cucumber/aruba/tree/master/features/matchers/file/have_file_size.feature)
  * [path](https://github.com/cucumber/aruba/tree/master/features/matchers/path)
    * [be an absolute path](https://github.com/cucumber/aruba/tree/master/features/matchers/path/be_an_absolute_path.feature)
    * [be an existing path](https://github.com/cucumber/aruba/tree/master/features/matchers/path/be_an_existing_path.feature)
    * [have permissions](https://github.com/cucumber/aruba/tree/master/features/matchers/path/have_permissions.feature)
  * [timeouts](https://github.com/cucumber/aruba/tree/master/features/matchers/timeouts.feature)

* [Platforms](https://github.com/cucumber/aruba/tree/master/features/platforms)
      * [jruby](https://github.com/cucumber/aruba/tree/master/features/platforms/jruby.feature)

* [Our API](https://github.com/cucumber/aruba/tree/master/features/api)
  * [Commands](https://github.com/cucumber/aruba/tree/master/features/api/command)
    * [find command](https://github.com/cucumber/aruba/tree/master/features/api/command/find_command.feature)
    * [last command started](https://github.com/cucumber/aruba/tree/master/features/api/command/last_command_started.feature)
    * [last command stopped](https://github.com/cucumber/aruba/tree/master/features/api/command/last_command_stopped.feature)
    * [run](https://github.com/cucumber/aruba/tree/master/features/api/command/run.feature)
    * [run simple](https://github.com/cucumber/aruba/tree/master/features/api/command/run_simple.feature)
    * [send signal](https://github.com/cucumber/aruba/tree/master/features/api/command/send_signal.feature)
    * [stderr](https://github.com/cucumber/aruba/tree/master/features/api/command/stderr.feature)
    * [stdout](https://github.com/cucumber/aruba/tree/master/features/api/command/stdout.feature)
    * [stop all commands](https://github.com/cucumber/aruba/tree/master/features/api/command/stop_all_commands.feature)
    * [stop](https://github.com/cucumber/aruba/tree/master/features/api/command/stop.feature)
    * [terminate all commands](https://github.com/cucumber/aruba/tree/master/features/api/command/terminate_all_commands.feature)
    * [which](https://github.com/cucumber/aruba/tree/master/features/api/command/which.feature)
  * [Core](https://github.com/cucumber/aruba/tree/master/features/api/core)
    * [expand path](https://github.com/cucumber/aruba/tree/master/features/api/core/expand_path.feature)
  * [Environment](https://github.com/cucumber/aruba/tree/master/features/api/environment)
    * [append environment variable](https://github.com/cucumber/aruba/tree/master/features/api/environment/append_environment_variable.feature)
    * [delete environment variable](https://github.com/cucumber/aruba/tree/master/features/api/environment/delete_environment_variable.feature)
    * [prepend environment variable](https://github.com/cucumber/aruba/tree/master/features/api/environment/prepend_environment_variable.feature)
    * [set environment variable](https://github.com/cucumber/aruba/tree/master/features/api/environment/set_environment_variable.feature)
  * [Filesystem](https://github.com/cucumber/aruba/tree/master/features/api/filesystem)
    * [cd](https://github.com/cucumber/aruba/tree/master/features/api/filesystem/cd.feature)
    * [copy](https://github.com/cucumber/aruba/tree/master/features/api/filesystem/copy.feature)
    * [create directory](https://github.com/cucumber/aruba/tree/master/features/api/filesystem/create_directory.feature)
    * [disk usage](https://github.com/cucumber/aruba/tree/master/features/api/filesystem/disk_usage.feature)
    * [does exist](https://github.com/cucumber/aruba/tree/master/features/api/filesystem/does_exist.feature)
    * [is absolute](https://github.com/cucumber/aruba/tree/master/features/api/filesystem/is_absolute.feature)
    * [is directory](https://github.com/cucumber/aruba/tree/master/features/api/filesystem/is_directory.feature)
    * [is file](https://github.com/cucumber/aruba/tree/master/features/api/filesystem/is_file.feature)
    * [is relative](https://github.com/cucumber/aruba/tree/master/features/api/filesystem/is_relative.feature)
    * [move](https://github.com/cucumber/aruba/tree/master/features/api/filesystem/move.feature)
  * [Text](https://github.com/cucumber/aruba/tree/master/features/api/text)
    * [extract text](https://github.com/cucumber/aruba/tree/master/features/api/text/extract_text.feature)
    * [replace variables](https://github.com/cucumber/aruba/tree/master/features/api/text/replace_variables.feature)
    * [sanitize text](https://github.com/cucumber/aruba/tree/master/features/api/text/sanitize_text.feature)
    * [unescape text](https://github.com/cucumber/aruba/tree/master/features/api/text/unescape_text.feature)

### Developer Documentation

`aruba` provides a wonderful API to be used in your tests:

* Creating files/directories
* Deleting files/directories
* Checking file size
* Checking file existence/absence
* ...

A full documentation of the API can be found
[here](http://www.rubydoc.info/github/cucumber/aruba/master/frames).

## Contributing

Please see the [CONTRIBUTING](CONTRIBUTING.md) file.

## Copyright

Copyright (c) 2010-2016 Aslak Hellesøy et al. See [MIT License](LICENSE) for details.
