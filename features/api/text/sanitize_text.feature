Feature: Sanitize text from output

  If have got some text include \n, \t and the like and need them to become
  special characters again and also want the text to be stripped down to bare
  text, you can use the `#sanitize_text`-method for this.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Output contains \n
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    echo -n 'text\ntext'
    """
    And a file named "spec/sanitize_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      before(:each) { stop_all_commands }

      it { expect(sanitize_text(last_command_started.output)).to eq "text\ntext" }
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
    And a file named "spec/sanitize_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      before(:each) { stop_all_commands }

      it { expect(sanitize_text(last_command_started.output)).to eq "texttext" }
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
    And a file named "spec/sanitize_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      before(:each) { stop_all_commands }

      it { expect(sanitize_text(last_command_started.output)).to eq "text\"text" }
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
    And a file named "spec/sanitize_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      before(:each) { stop_all_commands }

      it { expect(sanitize_text(last_command_started.output)).to eq "texttext" }
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
    And a file named "spec/sanitize_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      before(:each) { stop_all_commands }

      it { expect(sanitize_text(last_command_started.output)).to eq "texttext" }
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
    And a file named "spec/sanitize_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      before(:each) { stop_all_commands }

      it { expect(sanitize_text(last_command_started.output)).to eq "texttext" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains ansi escape codes prefixed by \e
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    echo -n "\e[31mText"
    """
    And a file named "spec/sanitize_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      before(:each) { stop_all_commands }

      it { expect(sanitize_text(last_command_started.output)).to eq "Text" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains ansi escape codes prefixed by \033
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    echo -n "\033[31mText"
    """
    And a file named "spec/sanitize_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      before(:each) { stop_all_commands }

      it { expect(sanitize_text(last_command_started.output)).to eq "Text" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains ansi escape codes prefixed by \e, but removable is disabled by configuration
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    echo -n "\e[31mText"
    """
    And a file named "spec/sanitize_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba, :remove_ansi_escape_sequences => false, :keep_ansi => true do
      before(:each) { run('cli') }
      before(:each) { stop_all_commands }

      it { expect(sanitize_text(last_command_started.output)).to eq "\e[31mText" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

    # Scenario: Output contains ansi escape code \016
    #   Given an executable named "bin/cli" with:
    #   """
    #   #!/bin/bash
    #   echo -n "\016Text"
    #   """
    #   And a file named "spec/sanitize_spec.rb" with:
    #   """
    #   require 'spec_helper'
    #
    #   RSpec.describe 'Run command', :type => :aruba do
    #     before(:each) { run('cli') }
    #     before(:each) { stop_all_commands }
    #
    #     it { expect(sanitize_text(last_command_started.output)).to eq "Text" }
    #   end
    #   """
    #   When I run `rspec`
    #   Then the specs should all pass

    # Scenario: Output contains ansi escape code \017
    #   Given an executable named "bin/cli" with:
    #   """
    #   #!/bin/bash
    #   echo -n "\017Text"
    #   """
    #   And a file named "spec/sanitize_spec.rb" with:
    #   """
    #   require 'spec_helper'
    #
    #   RSpec.describe 'Run command', :type => :aruba do
    #     before(:each) { run('cli') }
    #     before(:each) { stop_all_commands }
    #
    #     it { expect(sanitize_text(last_command_started.output)).to eq "Text" }
    #   end
    #   """
    #   When I run `rspec`
    #   Then the specs should all pass
