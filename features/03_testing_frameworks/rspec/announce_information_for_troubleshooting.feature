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
      specify "run command", :announce_directory do
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
      specify "run command", :announce_stdout do
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
      specify "run command", :announce_stderr do
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

  Scenario: Announce both stderr and stdout
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'Hello' >&2
    echo 'World'
    """
    And a file named "spec/announcing_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Announce', type: :aruba do
      specify "run command", :announce_output do
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
    Hello

    STDERR
    """
    And the output should contain:
    """
    <<-STDOUT
    World

    STDOUT
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
      specify "run command", :announce_command do
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
      specify "run command", :announce_changed_environment do
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
      specify "run command", :announce_command_filesystem_status do
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
    This will output the content of the executable command. This hook should be
    used with scripts only. For binary executables, to prevent large garbage
    output, a short replacement message is displayed.

    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'Hello World'
    """
    And a file named "spec/announcing_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Announce', type: :aruba do
      specify "run command", :announce_command_content do
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

  Scenario: Announce everything
    Given an executable named "bin/aruba-test-cli" with:
    """bash
    #!/usr/bin/env bash

    echo 'Hello World'
    """
    And a file named "spec/announcing_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'Announce', type: :aruba do
      specify "run command", :announce do
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
