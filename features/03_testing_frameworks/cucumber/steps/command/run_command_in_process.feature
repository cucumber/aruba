Feature: Run commands in ruby process
  Running a lot of scenarios where each scenario uses Aruba
  to spawn a new ruby process can be time consuming.

  Aruba lets you plug in your own process class that can
  run a command in the same ruby process as Cucumber/Aruba.

  We expect that the command supports the following API. It needs to accept:
  argv, stdin, stdout, stderr and kernel on `#initialize` and it needs to have
  an `execute!`-method.

  ```ruby
  module Cli
    module App
      class Runner
        def initialize(argv, stdin, stdout, stderr, kernel)
          \@argv   = argv
          \@stdin  = stdin
          \@stdout = stdout
          \@stderr = stderr
          \@kernel = kernel
        end

        def execute!
        end
      end
    end
  end
  ```

  The switch to the working directory takes place around the `execute!`-method.
  If needed make sure, that you determine the current working directory within
  code called by the `execute!`-method or just use `Dir.getwd` during "runtime"
  and not during "loadtime", when the `ruby`-interpreter reads in you class
  files.

  *Pros*:
  * Very fast compared to spawning processes
  * You can use libraries like
    [simplecov](https://github.com/colszowka/simplecov) more easily, because
    there is only one "process" which adds data to `simplecov`'s database

  *Cons*:
  * You might oversee some bugs: You might forget to require libraries in your
    "production" code, because you have required them in your testing code
  * Using `:in_process` interactively is not supported

  **WARNING**: Using `:in_process` interactively is not supported

  Background:
    Given I use a fixture named "cli-app"
    And a file named "features/support/cli_app.rb" with:
    """
    require 'cli/app/runner'
    """
    And a file named "features/support/in_proccess.rb" with:
    """
    require 'aruba/cucumber'

    Before('@in-process') do
      aruba.config.command_launcher = :in_process
      aruba.config.main_class = Cli::App::Runner
    end

    After('@in-process') do
      aruba.config.command_launcher = :spawn
    end
    """

  Scenario: Run custom code
    Given a file named "lib/cli/app/runner.rb" with:
    """
    module Cli
      module App
        class Runner
          def initialize(argv, stdin, stdout, stderr, kernel)
            @argv   = argv
            @stdin  = stdin
            @stdout = stdout
            @stderr = stderr
            @kernel = kernel
          end

          def execute!
            @stdout.puts(@argv.map(&:reverse).join(' '))
          end
        end
      end
    end
    """
    And a file named "features/in_process.feature" with:
    """
    Feature: Run a command in process
      @in-process
      Scenario: Run command
        When I run `reverse.rb Hello World`
        Then the output should contain:
        \"\"\"
        olleH dlroW
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Mixing custom code and normal cli
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    echo $*
    """
    And a file named "lib/cli/app/runner.rb" with:
    """
    module Cli
      module App
        class Runner
          def initialize(argv, stdin, stdout, stderr, kernel)
            @argv   = argv
            @stdin  = stdin
            @stdout = stdout
            @stderr = stderr
            @kernel = kernel
          end

          def execute!
            @stdout.puts(@argv.map(&:reverse).join(' '))
          end
        end
      end
    end
    """
    And a file named "features/in_process.feature" with:
    """
    Feature: Run a command in process
      @in-process
      Scenario: Run command in process
        When I run `reverse.rb Hello World`
        Then the output should contain:
        \"\"\"
        olleH dlroW
        \"\"\"

      Scenario: Run command
        When I run `aruba-test-cli Hello World`
        Then the output should contain:
        \"\"\"
        Hello World
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: The current working directory is changed as well
    Given a file named "lib/cli/app/runner.rb" with:
    """
    module Cli
      module App
        class Runner
          def initialize(argv, stdin, stdout, stderr, kernel)
            @argv   = argv
            @stdin  = stdin
            @stdout = stdout
            @stderr = stderr
            @kernel = kernel
          end

          def execute!
            @stdout.puts("PWD-ENV is " + Dir.getwd)
          end
        end
      end
    end
    """
    And a file named "features/in_process.feature" with:
    """
    Feature: Run a command in process
      @in-process
      Scenario: Run command
        When I run `pwd.rb`
        Then the output should match %r<PWD-ENV.*tmp/aruba>
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: The PWD environment is changed to current working directory
    Given a file named "lib/cli/app/runner.rb" with:
    """
    module Cli
      module App
        class Runner
          def initialize(argv, stdin, stdout, stderr, kernel)
            @argv   = argv
            @stdin  = stdin
            @stdout = stdout
            @stderr = stderr
            @kernel = kernel
          end

          def execute!
            @stdout.puts("PWD-ENV is " + ENV['PWD'])
          end
        end
      end
    end
    """
    And a file named "features/in_process.feature" with:
    """
    Feature: Run a command in process
      @in-process
      Scenario: Run command
        When I run `pwd.rb`
        Then the output should match %r<PWD-ENV.*tmp/aruba>
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Set runner via "Aruba.process ="-method (deprecated)
    Given a file named "features/support/in_proccess.rb" with:
    """
    require 'aruba/cucumber'
    require 'aruba/processes/in_process'

    Before('@in-process') do
      Aruba.process = Aruba::Processes::InProcess
      Aruba.process.main_class = Cli::App::Runner
    end

    After('@in-process') do
      Aruba.process = Aruba::Processes::SpawnProcess
    end
    """
    Given a file named "lib/cli/app/runner.rb" with:
    """
    module Cli
      module App
        class Runner
          def initialize(argv, stdin, stdout, stderr, kernel)
            @argv   = argv
            @stdin  = stdin
            @stdout = stdout
            @stderr = stderr
            @kernel = kernel
          end

          def execute!
            @stdout.puts(@argv.map(&:reverse).join(' '))
          end
        end
      end
    end
    """
    And a file named "features/in_process.feature" with:
    """
    Feature: Run a command in process
      @in-process
      Scenario: Run command
        When I run `reverse.rb Hello World`
        Then the output should contain:
        \"\"\"
        olleH dlroW
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Set runner via "Aruba.process ="-method and use old class name Aruba::InProcess (deprecated)
    Given a file named "features/support/in_proccess.rb" with:
    """
    require 'aruba/cucumber'
    require 'aruba/in_process'
    require 'aruba/spawn_process'

    Before('@in-process') do
      Aruba.process = Aruba::InProcess
      Aruba.process.main_class = Cli::App::Runner
    end

    After('@in-process') do
      Aruba.process = Aruba::SpawnProcess
    end
    """
    Given a file named "lib/cli/app/runner.rb" with:
    """
    module Cli
      module App
        class Runner
          def initialize(argv, stdin, stdout, stderr, kernel)
            @argv   = argv
            @stdin  = stdin
            @stdout = stdout
            @stderr = stderr
            @kernel = kernel
          end

          def execute!
            @stdout.puts(@argv.map(&:reverse).join(' '))
          end
        end
      end
    end
    """
    And a file named "features/in_process.feature" with:
    """
    Feature: Run a command in process
      @in-process
      Scenario: Run command
        When I run `reverse.rb Hello World`
        Then the output should contain:
        \"\"\"
        olleH dlroW
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Use $stderr, $stdout and $stdin to access IO

    May may need/want to use the default `STDERR`, `STDOUT`, `STDIN`-constants
    to access IO from within your script. Unfortunately this does not work with
    the `:in_process`-command launcher. You need to use `$stderr`, `$stdout`
    and `$stdin` instead.

    For this example I chose `thor` to parse ARGV. Its `.start`-method accepts
    an "Array" as ARGV and a "Hash" for some other options &ndash; `.start <ARGV>, <OPTIONS>`

    Given a file named "lib/cli/app/runner.rb" with:
    """
    require 'cli/app/cli_parser'

    module Cli
      module App
        class Runner
          def initialize(argv, stdin, stdout, stderr, kernel)
            @argv   = argv
            $kernel = kernel
            $stdin  = stdin
            $stdout = stdout
            $stderr = stderr
          end

          def execute!
            Cli::App::CliParser.start @argv
          end
        end
      end
    end
    """
    And a file named "lib/cli/app/cli_parser.rb" with:
    """
    require 'thor'

    module Cli
      module App
        class CliParser < Thor
          def self.exit_on_failure?
            true
          end

          desc 'do_it', 'Reverse input'
          def do_it(*args)
            $stderr.puts 'Hey ya, Hey ya, check, check, check'
            $stdout.puts(args.flatten.map(&:reverse).join(' '))
          end
        end
      end
    end
    """
    And a file named "features/in_process.feature" with:
    """
    Feature: Run a command in process
      @in-process
      Scenario: Run command
        When I run `reverse.rb do_it Hello World`
        Then the stdout should contain:
        \"\"\"
        olleH dlroW
        \"\"\"
        And the stderr should contain:
        \"\"\"
        Hey ya, Hey ya, check, check, check
        \"\"\"
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Use $kernel to use Kernel to capture exit code

    Ruby's `Kernel`-module provides some helper methods like `exit`.
    Unfortunately running `#exit` with `:in_process` would make the whole ruby
    interpreter exit. So you might want to use our `FakeKernel`-module module
    instead which overwrites `#exit`. This will also make our tests for
    checking the exit code work. This example also uses the `thor`-library.

    Given a file named "lib/cli/app/runner.rb" with:
    """
    require 'cli/app/cli_parser'

    module Cli
      module App
        class Runner
          def initialize(argv, stdin, stdout, stderr, kernel)
            @argv   = argv
            $kernel = kernel
            $stdin  = stdin
            $stdout = stdout
            $stderr = stderr
          end

          def execute!
            Cli::App::CliParser.start @argv
          end
        end
      end
    end
    """
    And a file named "lib/cli/app/cli_parser.rb" with:
    """
    require 'thor'

    module Cli
      module App
        class CliParser < Thor
          def self.exit_on_failure?
            true
          end

          desc 'do_it', 'Reverse input'
          def do_it(*args)
            $kernel.exit 5
          end
        end
      end
    end
    """
    And a file named "features/in_process.feature" with:
    """
    Feature: Run a command in process
      @in-process
      Scenario: Run command
        When I run `reverse.rb do_it`
        Then the exit status should be 5
    """
    When I run `cucumber`
    Then the features should all pass

  Scenario: Using `:in_process` interactively is not supported

    Reading from STDIN blocks ruby from going on. But writing to STDIN - e.g.
    type some letters on keyboard - can only appear later, but this point is
    never reached, because ruby is blocked.

    Given the default aruba exit timeout is 5 seconds
    And a file named "lib/cli/app/runner.rb" with:
    """
    module Cli
      module App
        class Runner
          def initialize(argv, stdin, stdout, stderr, kernel)
            @stdin  = stdin
          end

          def execute!
            while res = @stdin.gets.to_s.chomp
              break if res == 'quit'
              puts res.reverse
            end
          end
        end
      end
    end
    """
    And a file named "features/in_process.feature" with:
    """
    Feature: Run a command in process
      @in-process
      Scenario: Run command
        Given the default aruba exit timeout is 2 seconds
        When I run `reverse.rb do_it` interactively
        When I type "hello"
        Then the output should contain:
        \"\"\"
        hello
        \"\"\"
    """
    When I run `cucumber`
    Then the exit status should not be 0
