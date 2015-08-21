Feature: Extract text from output

  If you need to strip down some command output to plain text, you can use the
  `#extract_text`-method for this.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Output contains ansi escape codes prefixed by \e
    Given an executable named "bin/cli" with:
    """
    #!/bin/bash
    echo -n "\e[31mText"
    """
    And a file named "spec/extract_text_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      before(:each) { stop_all_commands }

      it { expect(extract_text(unescape_text(last_command.output))).to eq "Text" }
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
    And a file named "spec/extract_text_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run('cli') }
      before(:each) { stop_all_commands }

      it { expect(extract_text(unescape_text(last_command.output))).to eq "Text" }
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
    #   And a file named "spec/extract_text_spec.rb" with:
    #   """
    #   require 'spec_helper'
    #
    #   RSpec.describe 'Run command', :type => :aruba do
    #     before(:each) { run('cli') }
    #     before(:each) { stop_all_commands }
    #
    #     it { expect(extract_text(unescape_text(last_command.output))).to eq "Text" }
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
    #   And a file named "spec/extract_text_spec.rb" with:
    #   """
    #   require 'spec_helper'
    #
    #   RSpec.describe 'Run command', :type => :aruba do
    #     before(:each) { run('cli') }
    #     before(:each) { stop_all_commands }
    #
    #     it { expect(extract_text(unescape_text(last_command.output))).to eq "Text" }
    #   end
    #   """
    #   When I run `rspec`
    #   Then the specs should all pass
