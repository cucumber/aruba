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
    Given an executable named "bin/cli" with:
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
        When I run `cli Hello World`
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
