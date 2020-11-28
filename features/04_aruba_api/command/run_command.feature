Feature: Run command

  To run a command use the `#run_command` method. There are some configuration options
  which are relevant here:

  - `startup_wait_time`:

    Given this option `aruba` waits n seconds after it started the command.
    This is most useful when using `#run_command()` and not really makes sense for
    `#run_command_and_stop()`.

    You can use `#run_command()` + `startup_wait_time` to start background jobs.

  - `exit_timeout`:

    The exit timeout is used, when `aruba` waits for a command to finished.

  - `io_wait_timeout`:

    The io wait timeout is used, when you access `stdout` or `stderr` of a
    command.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Executable in the project's path 
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    exit 0
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba do
      before { run_command('aruba-test-cli') }
      it { expect(last_command_started).to be_successfully_executed }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Executable in a relative path in the Aruba working directory
    Given a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba do
      before do
        write_file 'bin/aruba-test-cli', <<~BASH
          #!/bin/bash
          exit 0
        BASH
        chmod 0o755, 'bin/aruba-test-cli'
      end

      it "runs the command" do
        run_command('bin/aruba-test-cli')
        expect(last_command_started).to be_successfully_executed
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Non-existing executable
    Given a file named "bin/aruba-test-cli" does not exist
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Find path for command', type: :aruba do
      it { expect { run_command('aruba-test-cli') }.to raise_error Aruba::LaunchError, /Command "aruba-test-cli" not found in PATH-variable/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Command with long startup phase

    If you have got a command with a long startup phase or use `ruby` together
    with `bundler`, you should consider using the `startup_wait_time`-option.
    Otherwise methods like `#send_signal` don't work since they require the
    command to be running and have setup it's signal handler.

    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    function initialize_script {
      sleep 0.2
    }

    function do_some_work {
      echo "Hello, Aruba is working"
    }

    function recurring_work {
      echo "Hello, Aruba here"
    }

    function stop_script {
      exit 0
    }

    trap recurring_work HUP
    trap stop_script TERM

    initialize_script
    do_some_work

    while [ true ]; do sleep 0.1; done
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba, exit_timeout: 0.1, startup_wait_time: 0.3 do
      before do
        run_command('aruba-test-cli')
        last_command_started.send_signal 'HUP'
      end

      it 'runs the command with the expected results' do
        aggregate_failures do
          expect(last_command_started).to be_successfully_executed
          expect(last_command_started).to have_output /Hello, Aruba is working/
          expect(last_command_started).to have_output /Hello, Aruba here/
        end
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Long running command

    If you have got a "long running" command, you should consider using the
    `exit_timeout`-option.

    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    function do_some_work {
      sleep 0.1
      echo "Hello, Aruba here"
    }

    do_some_work
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba, exit_timeout: 0.3 do
      before { run_command('aruba-test-cli') }

      it 'runs the command with the expected results' do
        aggregate_failures do
          expect(last_command_started).to be_successfully_executed
          expect(last_command_started).to have_output /Hello, Aruba here/
        end
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Mixing commands with long and short startup phase

    If you commands with a long and short startup phases, you should consider
    using the `startup_wait_time`-option local to the `#run_command`-call.

    Given an executable named "bin/aruba-test-cli1" with:
    """bash
    #!/usr/bin/env bash

    function initialize_script {
      sleep 0.2
    }

    function do_some_work {
      echo "Hello, Aruba 1 is working"
    }

    function recurring_work {
      echo "Hello, Aruba 1 here"
    }

    function stop_script {
      exit 0
    }

    trap recurring_work HUP
    trap stop_script TERM

    initialize_script
    do_some_work

    while [ true ]; do sleep 0.1; done
    """
    And an executable named "bin/aruba-test-cli2" with:
    """bash
    #!/usr/bin/env bash

    function initialize_script {
      sleep 0
    }

    function do_some_work {
      echo "Hello, Aruba 2 is working"
    }

    function recurring_work {
      echo "Hello, Aruba 2 here"
    }

    function stop_script {
      exit 0
    }

    trap recurring_work HUP
    trap stop_script TERM

    initialize_script
    do_some_work

    while [ true ]; do sleep 0.1; done
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba, exit_timeout: 0.1 do
      before do
        run_command 'aruba-test-cli1', startup_wait_time: 0.3
        run_command 'aruba-test-cli2', startup_wait_time: 0.1
        last_command_started.send_signal 'HUP'
      end

      it 'runs both commands with the expected results' do
        cli1 = find_command('aruba-test-cli1')
        cli2 = find_command('aruba-test-cli2')
        aggregate_failures do
          expect(cli1).to be_successfully_executed
          expect(cli1).to have_output /Hello, Aruba 1 is working/
          expect(cli1).not_to have_output /Hello, Aruba 1 here/
          expect(cli2).to be_successfully_executed
          expect(cli2).to have_output /Hello, Aruba 2 is working/
          expect(cli2).to have_output /Hello, Aruba 2 here/
        end
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Mixing long and short running commands

    If need to mix "long running" and "short running" commands, you should consider using the
    `exit_timeout`-option local to the `#run_command`-method.

    Given an executable named "bin/aruba-test-cli1" with:
    """bash
    #!/usr/bin/env bash

    function do_some_work {
      sleep 0.2
      echo "Hello, Aruba 1 here"
    }

    do_some_work
    """
    And an executable named "bin/aruba-test-cli2" with:
    """bash
    #!/usr/bin/env bash

    function do_some_work {
      echo "Hello, Aruba 2 here"
    }

    do_some_work
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba do
      before do
        run_command 'aruba-test-cli1', exit_timeout: 0.4
        run_command 'aruba-test-cli2', exit_timeout: 0.1
      end

      it 'runs both commands with the expected results' do
        cli1 = find_command('aruba-test-cli1')
        cli2 = find_command('aruba-test-cli2')
        aggregate_failures do
          expect(cli1).to be_successfully_executed
          expect(cli1).to have_output /Hello, Aruba 1 here/
          expect(cli2).to be_successfully_executed
          expect(cli2).to have_output /Hello, Aruba 2 here/
        end
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Starting command twice fails
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    exit 0
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', type: :aruba do
      before { run_command('aruba-test-cli') }
      let!(:found_command) { find_command('aruba-test-cli') }
      it { expect { found_command.start }.to raise_error Aruba::CommandAlreadyStartedError }
    end
    """
    When I run `rspec`
    Then the specs should all pass
