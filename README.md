[![Build Status](https://secure.travis-ci.org/cucumber/aruba.png)](http://travis-ci.org/cucumber/aruba) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/cucumber/aruba)

Aruba is Cucumber extension for Command line applications written in any programming language. Features at a glance:

* Test any command line application
* Manipulate the file system
* Create great HTML documentation based on your own Cucumber scenarios

## Usage

If you have a `Gemfile`, add `aruba`. Otherwise, install it like this:

    gem install aruba

Then, `require` the library in one of your ruby files under `features/support` (e.g. `env.rb`)

    require 'aruba/cucumber'

You now have a bunch of step definitions that you can use in your features. Look at `lib/aruba/cucumber.rb`
to see them all. Look at `features/*.feature` for examples (which are also testing Aruba
itself).

## Configuration

Aruba has some default behaviour that you can change if you need to.

### Use a different working directory

Per default Aruba will create a directory `tmp/aruba` where it performs its file operations.
If you want to change this behaviour put this into your `features/support/env.rb`:

    Before do
      @dirs = ["somewhere/else"]
    end


### Modify the PATH

Aruba will automatically add the `bin` directory of your project to the `PATH` environment variable for 
the duration of each Cucumber scenario. So if you're developing a Ruby gem with a binary command, you
can test those commands as though the gem were already installed.

If you need other directories to be added to the `PATH`, you can put the following in `features/support/env.rb`:

    ENV['PATH'] = "/my/special/bin/path')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

### Increasing timeouts

A process sometimes takes longer than expected to terminate, and Aruba will kill them off (and fail your scenario) if it is still alive after 3 seconds. If you need more time you can modify the timeout by assigning a different value to `@aruba_timeout_seconds` in a `Before` block: 

    Before do
      @aruba_timeout_seconds = 5
    end

### Increasing IO wait time

Running processes interactively can result in race conditions when Aruba executes an IO-related step
but the interactive process has not yet flushed or read some content. To help prevent this Aruba waits
before reading or writing to the process if it is still running. You can control the wait by setting
`@aruba_io_wait_seconds` to an appropriate value. This is particularly useful with tags:

    Before('@slow_process') do
      @aruba_io_wait_seconds = 5
    end

### Tags

Aruba defines several tags that you can put on on individual scenarios, or on a feature.

#### Seeing more output with `@announce-*`

To get more information on what Aruba is doing, use these tags:

* `@announce-cmd` - See what command is run
* `@announce-stdout` - See the stdout
* `@announce-stderr` - See the stderr
* `@announce-dir` - See the current directory
* `@announce-env` - See environment variables set by Aruba
* `@announce` - Does all of the above

### Adding Hooks

You can hook into Aruba's lifecycle just before it runs a command:

```ruby
Aruba.configure do |config|
  config.before_cmd do |cmd|
    puts "About to run '#{cmd}'"
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

### JRuby Tips

Improve startup time by disabling JIT and forcing client JVM mode.  This can be accomplished by adding

    require 'aruba/java'

or setting a hook like this example:

```
    Aruba.configure do |config|
      config.before_cmd do |cmd|
        set_env('JRUBY_OPTS', "-X-C #{ENV['JRUBY_OPTS']}") # disable JIT since these processes are so short lived
        set_env('JAVA_OPTS', "-d32 #{ENV['JAVA_OPTS']}") # force jRuby to use client JVM for faster startup times
      end
    end if RUBY_PLATFORM == 'java'
```

*Note* - no conflict resolution on the JAVA/JRuby environment options is
done; only merging. For more complex settings please manually set the
environment variables in the hook or externally.

A larger process timeout for java may be needed

```
    Before do
      @aruba_timeout_seconds = RUBY_PLATFORM == 'java' ? 60 : 10
    end
```

Refer to http://blog.headius.com/2010/03/jruby-startup-time-tips.html for other tips on startup time.

## Reporting

*Important* - you need [Pygments](http://pygments.org/) installed to use this feature.

Aruba can generate a HTML page for each scenario that contains:

* The title of the scenario
* The description from the scenario (You can use Markdown here)
* The command(s) that were run
* The output from those commands (in colour if the output uses ANSI escapes)
* The files that were created (syntax highlighted in in colour)

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

    Scenario: Make tea
      ## Making tea
      * Get a pot
      * And some hot water
      
      Given...

You'd write:

    Scenario: Make tea
      \## Making tea
      \* Get a pot
      \* And some hot water
  
      Given...

This way Gherkin won't recognize these lines as special tokens, and the reporter will render them as Markdown. (The reporter strips
away any leading the backslashes before handing it off to the Markdown parser).

Another option is to use alternative Markdown syntax and omit conflicts and escaping altogether:

    Scenario: Make tea
      Making tea
      ----------
      - Get a pot
      - And some hot water
  
      Given...

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.  Note: the existing tests may fail
* Commit, do not mess with Rakefile, gemspec or History.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010,2011 Aslak Hellesøy, David Chelimsky and Mike Sassak. See LICENSE for details.
