Feature: Extract text from output

  If you need to strip down some command output to plain text, you can use the
  `#unescape_text`-method for this.

  You may want to have a look
  [here](http://www.unixwerk.eu/unix/ansicodes.html) for a good overview for
  ANSI escape sequences.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Output contains \n
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    echo -n 'text\ntext'
    """
    And a file named "spec/which_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli').stop(announcer) }
      it { expect(unescape_text(last_command.output)).to eq "text\ntext" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains \e
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    echo -n 'text\etext'
    """
    And a file named "spec/which_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli').stop(announcer) }
      it { expect(unescape_text(last_command.output)).to eq "texttext" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains \"
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    echo -n 'text\"text'
    """
    And a file named "spec/which_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli').stop(announcer) }
      it { expect(unescape_text(last_command.output)).to eq "text\"text" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains \033
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    echo -n 'text\033text'
    """
    And a file named "spec/which_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli').stop(announcer) }
      it { expect(unescape_text(last_command.output)).to eq "texttext" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains \017
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    echo -n 'text\017text'
    """
    And a file named "spec/which_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli').stop(announcer) }
      it { expect(unescape_text(last_command.output)).to eq "texttext" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains \016
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    echo -n 'text\016text'
    """
    And a file named "spec/which_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli').stop(announcer) }
      it { expect(unescape_text(last_command.output)).to eq "texttext" }
    end
    """
    When I run `rspec`
    Then the specs should all pass
