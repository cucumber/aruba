Feature: Run command

  To run a command use the `#run`-method. There are some configuration options
  which are relevant here:

  - `startup_wait_time`:

    Given this option `aruba` waits n seconds after it started the command.
    This is most useful when using `#run()` and not really makes sense for
    `#run_simple()`.

    You can use `#run()` + `startup_wait_time` to start background jobs.

  - `exit_timeout`:

    The exit timeout is used, when `aruba` waits for a command to finished.

  - `io_wait_timeout`:

    The io wait timeout is used, when you access `stdout` or `stderr` of a
    command.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Existing executable
    Given an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    exit 0
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      it { expect(last_command_started).to be_successfully_executed }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Relative path to executable
    Given an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    exit 0
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('bin/cli') }
      it { expect(last_command_started).to be_successfully_executed }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Non-existing executable
    Given a file named "bin/cli" does not exist
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Find path for command', :type => :aruba do
      it { expect { run('cli') }.to raise_error Aruba::LaunchError, /Command "cli" not found in PATH-variable/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Command with long startup phase

    If you have got a command with a long startup phase or use `ruby` together
    with `bundler`, you should consider using the `startup_wait_time`-option.
    Otherwise methods like `#send_signal` don't work since they require the
    command to be running and have setup it's signal handler.

    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash
 
    function initialize_script {
      sleep 2
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

    while [ true ]; do sleep 1; done
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 1, :startup_wait_time => 2 do
      before(:each) { run('cli') }
      before(:each) { last_command_started.send_signal 'HUP' }

      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output /Hello, Aruba is working/ }
      it { expect(last_command_started).to have_output /Hello, Aruba here/ }

    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Long running command

    If you have got a "long running" command, you should consider using the
    `exit_timeout`-option.

    Given an executable named "bin/cli" with:
    """bash
    #!/usr/bin/env bash

    function do_some_work {
      sleep 2
      echo "Hello, Aruba here"
    }

    do_some_work
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 3 do
      before(:each) { run('cli') }

      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output /Hello, Aruba here/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Mixing commands with long and short startup phase (deprecated)

    If you commands with a long and short startup phases, you should consider
    using the `startup_wait_time`-option local to the `#run`-call.

    Given an executable named "bin/cli1" with:
    """bash
    #!/usr/bin/env bash
 
    function initialize_script {
      sleep 2
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

    while [ true ]; do sleep 0.2; done
    """
    And an executable named "bin/cli2" with:
    """bash
    #!/usr/bin/env bash

    function initialize_script {
      sleep 0
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

    while [ true ]; do sleep 0.2; done
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 1 do
      before(:each) { run('cli1', 3, 0.1, 'TERM', 2) }
      before(:each) { run('cli2', 3, 0.1, 'TERM', 1) }
      before(:each) { last_command_started.send_signal 'HUP' }

      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output /Hello, Aruba is working/ }
      it { expect(last_command_started).to have_output /Hello, Aruba here/ }

    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Mixing commands with long and short startup phase

    If you commands with a long and short startup phases, you should consider
    using the `startup_wait_time`-option local to the `#run`-call.

    Given an executable named "bin/cli1" with:
    """bash
    #!/usr/bin/env bash
 
    function initialize_script {
      sleep 2
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

    while [ true ]; do sleep 0.2; done
    """
    And an executable named "bin/cli2" with:
    """bash
    #!/usr/bin/env bash

    function initialize_script {
      sleep 0
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

    while [ true ]; do sleep 0.2; done
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 1 do
      before(:each) { run('cli1', :startup_wait_time => 2) }
      before(:each) { run('cli2', :startup_wait_time => 1) }
      before(:each) { last_command_started.send_signal 'HUP' }

      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output /Hello, Aruba is working/ }
      it { expect(last_command_started).to have_output /Hello, Aruba here/ }

    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Mixing long and short running commands (deprecated)

    If need to mix "long running" and "short running" commands, you should consider using the
    `exit_timeout`-option local to the `#run`-method.

    Given an executable named "bin/cli1" with:
    """bash
    #!/usr/bin/env bash

    function do_some_work {
      sleep 2
      echo "Hello, Aruba here"
    }

    do_some_work
    """
    And an executable named "bin/cli2" with:
    """bash
    #!/usr/bin/env bash

    function do_some_work {
      echo "Hello, Aruba here"
    }

    do_some_work
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli1', 3) }
      before(:each) { run('cli2', 1) }

      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output /Hello, Aruba here/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Mixing long and short running commands

    If need to mix "long running" and "short running" commands, you should consider using the
    `exit_timeout`-option local to the `#run`-method.

    Given an executable named "bin/cli1" with:
    """bash
    #!/usr/bin/env bash

    function do_some_work {
      sleep 2
      echo "Hello, Aruba here"
    }

    do_some_work
    """
    And an executable named "bin/cli2" with:
    """bash
    #!/usr/bin/env bash

    function do_some_work {
      echo "Hello, Aruba here"
    }

    do_some_work
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli1', :exit_timeout => 3) }
      before(:each) { run('cli2', :exit_timeout => 1) }

      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output /Hello, Aruba here/ }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Starting command twice fails
    Given an executable named "bin/cli" with:
    """bash
    #!/bin/bash
    exit 0
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      let!(:found_command) { find_command('cli') }
      it { expect { found_command.start }.to raise_error Aruba::CommandAlreadyStartedError }
    end
    """
    When I run `rspec`
    Then the specs should all pass
