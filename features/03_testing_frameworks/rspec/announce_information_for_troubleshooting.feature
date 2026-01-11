Feature: Announce information during rspec run

  In order to make debugging easier
  As a developer using RSpec
  I want to have certain information announced

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Announce change of directory
    Given a file named "spec/announcing_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Announce', type: :aruba do
      before do
        aruba.announcer.activate :directory
      end

      specify "run command" do
        create_directory "dir.d"
        cd "dir.d"
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    $ cd /
    """
    And the output should contain:
    """
    tmp/aruba/dir.d
    """

  Scenario: Announce stdout
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'Hello World'
    """
    And a file named "spec/announcing_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Announce', type: :aruba do
      before do
        aruba.announcer.activate :stdout
      end

      specify "run command" do
        run_command_and_stop "aruba-test-cli"
        expect(last_command_stopped).to be_successfully_executed
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    <<-STDOUT
    Hello World

    STDOUT
    """

  Scenario: Announce stderr
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'Hello World' >&2
    """
    And a file named "spec/announcing_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Announce', type: :aruba do
      before do
        aruba.announcer.activate :stderr
      end

      specify "run command" do
        run_command_and_stop "aruba-test-cli"
        expect(last_command_stopped).to be_successfully_executed
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    <<-STDERR
    Hello World

    STDERR
    """

  Scenario: Announce command
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'Hello World'
    """
    And a file named "spec/announcing_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Announce', type: :aruba do
      before do
        aruba.announcer.activate :command
      end

      specify "run command" do
        run_command_and_stop "aruba-test-cli"
        expect(last_command_stopped).to be_successfully_executed
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    $ aruba-test-cli
    """

  Scenario: Announce change of environment variable
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'Hello World'
    """
    And a file named "spec/announcing_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Announce', type: :aruba do
      before do
        aruba.announcer.activate :changed_environment
      end

      specify "run command" do
        set_environment_variable("MY_VAR", "my_value")
        run_command_and_stop "aruba-test-cli"
        expect(last_command_stopped).to be_successfully_executed
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    $ export MY_VAR=my_value
    """

  Scenario: Announce file system status of command
    This will output information like owner, group, atime, mtime, ctime, size,
    mode and if command is executable.

    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'Hello World'
    """
    And a file named "spec/announcing_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Announce', type: :aruba do
      before do
        aruba.announcer.activate :command_filesystem_status
      end

      specify "run command" do
        run_command_and_stop "aruba-test-cli"
        expect(last_command_stopped).to be_successfully_executed
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    # mode       => 755
    """
    And the output should contain:
    """
    # owner
    """
    And the output should contain:
    """
    # group
    """
    And the output should contain:
    """
    # ctime
    """
    And the output should contain:
    """
    # mtime
    """
    And the output should contain:
    """
    # atime
    """
    And the output should contain:
    """
    # size
    """
    And the output should contain:
    """
    # executable
    """

  Scenario: Announce content of command
    This will output the content of the executable command. Be careful doing
    this with binary executables. This hook should be used with scripts only.

    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'Hello World'
    """
    And a file named "spec/announcing_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Announce', type: :aruba do
      before do
        aruba.announcer.activate :command_content
      end

      specify "run command" do
        run_command_and_stop "aruba-test-cli"
        expect(last_command_stopped).to be_successfully_executed
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    #!/usr/bin/env bash

    echo 'Hello World'
    """

  Scenario: Acctivate several announcers
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'Hello World'
    """
    And a file named "spec/announcing_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Announce', type: :aruba do
      before do
        aruba.announcer.activate :stdout
        aruba.announcer.activate :stderr
        aruba.announcer.activate :command_content
        aruba.announcer.activate :command_filesystem_status
      end

      specify "run command" do
        run_command_and_stop "aruba-test-cli"
        expect(last_command_stopped).to be_successfully_executed
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass
    And the output should contain:
    """
    <<-STDOUT
    Hello World

    STDOUT
    """
    And the output should contain:
    """
    <<-STDERR

    STDERR
    """
    And the output should contain:
    """
    <<-COMMAND
    #!/usr/bin/env bash

    echo 'Hello World'
    COMMAND
    """
    And the output should contain:
    """
    <<-COMMAND FILESYSTEM STATUS
    """
