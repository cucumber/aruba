[![Build Status](https://travis-ci.org/cucumber/aruba.svg)](http://travis-ci.org/cucumber/aruba)
[![Gem Version](https://badge.fury.io/rb/aruba.svg)](http://badge.fury.io/rb/aruba)
[![Dependency Status](https://gemnasium.com/cucumber/aruba.svg)](https://gemnasium.com/cucumber/aruba)
[![Code Climate](https://codeclimate.com/github/cucumber/aruba.svg)](https://codeclimate.com/github/cucumber/aruba)
[![Join the chat at https://gitter.im/cucumber/aruba](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/cucumber/aruba?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

`aruba` is an extension for popular TDD and BDD frameworks like "Cucumber" and "RSpec" to make testing of commandline applications meaningful, easy and fun.

Features at a glance:

* Test any command line application, implemented in any programming language - e.g. Bash, Python, Ruby, Java
* Manipulate the file system and the process environment
* Automatically reset state of file system and process environment between tests

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

### Cucumber

To use `aruba` with cucumber, `require` the library in one of your ruby files
under `features/support` (e.g. `env.rb`)

```ruby
require 'aruba/cucumber'
```

You now have a bunch of step definitions that you can use in your features. Look at [`lib/aruba/cucumber.rb`](lib/aruba/cucumber.rb)
to see them all. Look at [`features/*.feature`](features/) for examples (which are also testing Aruba
itself).

### RSpec

Originally written for `cucumber`, `aruba` can be helpful in other contexts as
well. One might want to use it together with `rspec`.

1. Create a directory named `spec/support`
2. Create a file named `spec/support/aruba.rb` with:

  ```ruby
  require 'aruba/rspec'
  ```

3. Add the following to your `spec/spec_helper.rb`

  ```ruby
  Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
  ```

4. Add a type to your specs

  ```ruby
  RSpec.describe 'My feature', type: :aruba do
    # [...]
  end
  ```

## API

`aruba` provides a wonderful API to be used in your tests:

* Creating files/directories
* Deleting files/directories
* Checking file size
* Checking file existence/absence
* ...

A full documentation of the API can be found [here](http://www.rubydoc.info/github/cucumber/aruba/master/frames).

## Configuration

Aruba has some default behaviour that you can change if you need to.

### Use a different working directory

Per default Aruba will create a directory `tmp/aruba` where it performs its file operations.
If you want to change this behaviour put this into your `features/support/env.rb`:

```ruby
Before do
  @dirs = ["somewhere/else"]
end
```

### Modify the PATH

Aruba will automatically add the `bin` directory of your project to the `PATH` environment variable for
the duration of each Cucumber scenario. So if you're developing a Ruby gem with a binary command, you
can test those commands as though the gem were already installed.

If you need other directories to be added to the `PATH`, you can put the following in `features/support/env.rb`:

    ENV['PATH'] = "/my/special/bin/path#{File::PATH_SEPARATOR}#{ENV['PATH']}"

### Increasing timeouts

A process sometimes takes longer than expected to terminate, and Aruba will kill them off (and fail your scenario) if it is still alive after 3 seconds. If you need more time you can modify the timeout by assigning a different value to `@aruba_timeout_seconds` in a `Before` block:

```ruby
Before do
  @aruba_timeout_seconds = 5
end
```

### Increasing IO wait time

Running processes interactively can result in race conditions when Aruba executes an IO-related step
but the interactive process has not yet flushed or read some content. To help prevent this Aruba waits
before reading or writing to the process if it is still running. You can control the wait by setting
`@aruba_io_wait_seconds` to an appropriate value. This is particularly useful with tags:

```ruby
Before('@slow_process') do
  @aruba_io_wait_seconds = 5
end
```

### Tags

Aruba defines several tags that you can put on on individual scenarios, or on a feature.

#### Seeing more output with `@announce-*`

To get more information on what Aruba is doing, use these tags:

* `@announce-command` - See what command is run
* `@announce-stdout` - See the stdout
* `@announce-stderr` - See the stderr
* `@announce-output` - See the output of stdout and stderr
* `@announce-directory` - See the current directory
* `@announce-environment` - See environment variables set by Aruba
* `@announce` - Does all of the above

### Adding Hooks

You can hook into Aruba's lifecycle just before it runs a command and after it has run the command:

```ruby
Aruba.configure do |config|
  config.before :command do |cmd|
    puts "About to run '#{cmd}'"
  end

  config.after :command do |cmd|
    puts "After the run of '#{cmd}'"
  end
end
```

#### Keep files around with `@no-clobber`

Aruba clobbers all files in its working directory before each scenario. -Unless you tag it with `@no-clobber`

#### Making assertions about ANSI escapes with `@ansi`

Aruba strips away ANSI escapes from the stdout and stderr of spawned child processes by default. It's usually rather cumbersome to
make assertions about coloured output. Still, there might be cases where you want to leave the ANSI escapes intact. Just tag your
scenario with `@ansi`. Alternatively you can add your own Before
hook that sets `@aruba_keep_ansi = true`.

### Testing Ruby CLI programs without spawning a new Ruby process.

If your CLI program is written in Ruby you can speed up your suite of scenarios by running
your CLI in the same process as Cucumber/Aruba itself. In order to be able to do this, the
entry point for your CLI application must be a class that has a constructor with a particular
signature and an `execute!` method:

```ruby
class MyMain
  def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
  end

  def execute!
    # your code here, assign a value to exitstatus
    @kernel.exit(exitstatus)
  end
end
```

Your `bin/something` executable would look something like the following:

```ruby
require 'my_main'
MyMain.new(ARGV.dup).execute!
```

Then wire it all up in your `features/support/env.rb` file:

```ruby
require 'aruba'
require 'aruba/in_process'

Aruba.process = Aruba::Processes::InProcess
Aruba.process.main_class = MyMain
```

That's it! Everything will now run inside the same ruby process, making your suite
a lot faster. Cucumber itself uses this approach to test itself, so check out the
Cucumber source code for an example.

*Pros*:

* Very fast compared to spawning processes
* You can use libraries like
  [simplecov](https://github.com/colszowka/simplecov) more easily, because
  there is only one "process" which adds data to `simplecov`'s database

*Cons*:
* You might oversee some bugs: You might forget to require libraries in your
  "production" code, because you have required them in your testing code

### JRuby Tips

Improve startup time by disabling JIT and forcing client JVM mode.  This can be accomplished by adding

```ruby
require 'aruba/jruby'
```

or setting a hook like this example:

```ruby
Aruba.configure do |config|
  config.before :command do |cmd|
    set_env('JRUBY_OPTS', "-X-C #{ENV['JRUBY_OPTS']}") # disable JIT since these processes are so short lived
    set_env('JAVA_OPTS', "-d32 #{ENV['JAVA_OPTS']}") # force jRuby to use client JVM for faster startup times
  end
end if RUBY_PLATFORM == 'java'
```

*Note* - no conflict resolution on the JAVA/JRuby environment options is
done; only merging. For more complex settings please manually set the
environment variables in the hook or externally.

A larger process timeout for java may be needed

```ruby
Before do
  @aruba_timeout_seconds = RUBY_PLATFORM == 'java' ? 60 : 10
end
```

Refer to http://blog.headius.com/2010/03/jruby-startup-time-tips.html for other tips on startup time.

## Fixtures

Sometimes your tests need existing files to work - e.g binary data files you
cannot create programmatically. Since `aruba` >= 0.6.3 includes some basic
support for fixtures. All you need to do is the following:

1. Create a `fixtures`-directory
2. Create fixture files in this directory

The `expand_path`-helper will expand `%` to the path of your fixtures
directory:

```ruby
expand_path('%/song.mp3')
# => /home/user/projects/my_project/fixtures/song.mp3
```

*Example*

1. Create fixtures directory

  ```bash
  cd project
  
  mkdir -p fixtures/
  # or
  mkdir -p test/fixtures/
  # or
  mkdir -p spec/fixtures/
  # or
  mkdir -p features/fixtures/
  ```

2. Store `song.mp3` in `fixtures`-directory

  ```bash
  cp song.mp3 fixtures/
  ```

3. Add fixture to vcs-repository - e.g. `git`, `mercurial`

4. Create test

  ```ruby
  RSpec.describe 'My Feature' do
    describe '#read_music_file' do
      context 'when the file exists' do
        let(:path) { expand_path('%/song.mp3') }

        before :each do
          cd('.') { FileUtils.cp path, 'file.mp3' }
        end

        before :each do
          run 'my_command'
        end

        it { expect(all_stdout).to include('Rate is 128 KB') }
      end
    end
  end
  ```

## Reporting

*Important* - you need [Pygments](http://pygments.org/) installed to use this feature.

Aruba can generate a HTML page for each scenario that contains:

* The title of the scenario
* The description from the scenario (You can use Markdown here)
* The command(s) that were run
* The output from those commands (in colour if the output uses ANSI escapes)
* The files that were created (syntax highlighted in colour)

In addition to this, it creates an `index.html` file with links to all individual report files.
Reporting is off by default, but you can enable it by defining the `ARUBA_REPORT_DIR` environment variable, giving it the value
where reports should be written:

    ARUBA_REPORT_DIR=doc cucumber features

This will use Aruba's built-in template by default (See the `templates` folder). If you want to use your own template you can override its location:

    ARUBA_REPORT_TEMPLATES=templates ARUBA_REPORT_DIR=doc cucumber features

The templates directory must contain a `main.erb` and `files.erb` template. It can also contain other assets such
as css, javascript and images. All of these files will be copied over to the report dir well.

### Escaping Markdown

There are some edge cases where Gherkin and Markdown don't agree. Bullet lists using `*` is one example. The `*` is also an alias for
step keywords in Gherkin. Markdown headers (the kind starting with a `#`) is another example. They are parsed as comments by Gherkin. To use either of these, just escape them with a backslash. So instead of writing:

```gherkin
Scenario: Make tea
  ## Making tea
  * Get a pot
  * And some hot water

  Given...
```

You'd write:

```gherkin
Scenario: Make tea
  \## Making tea
  \* Get a pot
  \* And some hot water

  Given...
```

This way Gherkin won't recognize these lines as special tokens, and the reporter will render them as Markdown. (The reporter strips
away any leading the backslashes before handing it off to the Markdown parser).

Another option is to use alternative Markdown syntax and omit conflicts and escaping altogether:

```gherkin
Scenario: Make tea
  Making tea
  ----------
  - Get a pot
  - And some hot water

  Given...
```

## Contributing

Please see the `CONTRIBUTING.md`.

## Copyright

Copyright (c) 2010,2011,2012,2013,2014 Aslak Hellesøy, David Chelimsky and Mike Sassak. See LICENSE for details.
