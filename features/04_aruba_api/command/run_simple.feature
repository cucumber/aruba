Feature: Run command in a simpler fashion

  To run a command use the `#run_command_and_stop`-method. There are some configuration options
  which are relevant here:

  - `fail_on_error`:

    Given this option is `true`, `aruba` fails if the `command` fails to run - exit code <> 0.

    For all other options see [run.feature](run.feature).

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Require executable to succeed (by default value)
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    exit 1
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      it { expect { run_command_and_stop('aruba-test-cli') }.to raise_error RSpec::Expectations::ExpectationNotMetError }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Require executable to succeed (set by option)
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    exit 1
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      it { expect { run_command_and_stop('aruba-test-cli', :fail_on_error => true) }.to raise_error }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Require executable to succeed (set by option, deprecated)
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    exit 1
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      it { expect { run_command_and_stop('aruba-test-cli', true) }.to raise_error }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Ignore failure of executable (set by option)
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    exit 1
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      it { expect { run_command_and_stop('aruba-test-cli', :fail_on_error => false) }.not_to raise_error }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Ignore failure of executable (set by option, deprecated)
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    exit 1
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      it { expect { run_command_and_stop('aruba-test-cli', false) }.not_to raise_error }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Command with long startup phase

    If you have got a command with a long startup phase or use `ruby` together
    with `bundler`, you should consider using the `startup_wait_time`-option.
    Otherwise methods like `#send_signal` don't work since they require the
    command to be running and have setup its signal handler.

    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    function initialize_script {
      sleep 0.2
    }

    function do_some_work {
      echo "Hello, Aruba is working"
    }

    initialize_script
    do_some_work

    exit 0
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 0.1, :startup_wait_time => 0.3 do
      before(:each) { run_command_and_stop('aruba-test-cli') }

      it 'runs the command with the expected results' do
        aggregate_failures do
          expect(last_command_started).to be_successfully_executed
          expect(last_command_started).to have_output /Hello, Aruba is working/
        end
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Long-running command

    If you have got a long-running command, you should consider using the
    `exit_timeout`-option.

    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    function do_some_work {
      sleep 0.2
      echo "Hello, Aruba here"
    }

    do_some_work
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 0.3 do
      before(:each) { run_command_and_stop('aruba-test-cli') }

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

  Scenario: Sending signals to commands started with `#run_command_and_stop()`

    Sending signals to a command which is started by
    `#run_command_and_stop()` does not make sense. The command is stopped internally when
    its exit status is checked.

    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    function initialize_script {
      sleep 0.1
    }

    function cleanup_script {
      sleep 0.1
    }

    function do_some_work {
      echo "Hello, Aruba is working"
    }

    trap stop_script TERM

    initialize_script
    do_some_work
    cleanup_script
    exit 0
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :exit_timeout => 0.2, :startup_wait_time => 0.2 do
      before { run_command_and_stop('aruba-test-cli') }

      it 'refuses to send a signal' do
        expect { last_command_started.send_signal 'HUP' }.
          to raise_error Aruba::CommandAlreadyStoppedError
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Activate announcer channels on failure

    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/bin/bash
    echo "Hello, I'm STDOUT"
    echo "Hello, I'm STDERR" 1>&2
    exit 1
    """
    And a file named "spec/run_spec.rb" with:
    """ruby
    require 'spec_helper'

    Aruba.configure do |config|
      config.activate_announcer_on_command_failure = [:stdout, :stderr]
    end

    RSpec.describe 'Run command', :type => :aruba do
      it { expect { run_command_and_stop('aruba-test-cli', :fail_on_error => true) }.to_not raise_error }
    end
    """
    When I run `rspec`
    Then the specs should not pass
    And the output should contain:
    """
    <<-STDOUT
    Hello, I'm STDOUT

    STDOUT
    <<-STDERR
    Hello, I'm STDERR

    STDERR
    """
