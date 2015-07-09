Feature: Run commands in ruby process

  Running a lot of scenarios where each scenario uses Aruba
  to spawn a new ruby process can be time consuming.

  Aruba lets you plug in your own process class that can
  run a command in the same ruby process as Cucumber/Aruba.

  Background:
    Given I use a fixture named "cli-app"

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
    And a file named "features/support/cli_app.rb" with:
    """
    require 'cli/app/runner'
    """
    And a file named "features/support/in_proccess.rb" with:
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
    And a file named "features/in_process.feature" with:
    """
    Feature: Exit status
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
    And a file named "features/support/cli_app.rb" with:
    """
    require 'cli/app/runner'
    """
    And a file named "features/support/in_proccess.rb" with:
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
    And a file named "features/in_process.feature" with:
    """
    Feature: Exit status
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
