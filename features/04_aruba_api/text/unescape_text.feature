Feature: Unescape special characters in text

  If have got some text include \n, \t and the like and need them to become
  special characters again, you can use the `#unescape_text`-method for this.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Output contains \n
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    echo -n 'text\ntext'
    """
    And a file named "spec/unescape_text_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run_command('aruba-test-cli') }
      before(:each) { stop_all_commands }

      it { expect(unescape_text(last_command.output)).to eq "text\ntext" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains \e
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    echo -n 'text\etext'
    """
    And a file named "spec/unescape_text_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run_command('aruba-test-cli') }
      before(:each) { stop_all_commands }

      it { expect(unescape_text(last_command.output)).to eq "texttext" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains \"
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    echo -n 'text\"text'
    """
    And a file named "spec/unescape_text_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run_command('aruba-test-cli') }
      before(:each) { stop_all_commands }

      it { expect(unescape_text(last_command.output)).to eq "text\"text" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains \033
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    echo -n 'text\033text'
    """
    And a file named "spec/unescape_text_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run_command('aruba-test-cli') }
      before(:each) { stop_all_commands }

      it { expect(unescape_text(last_command.output)).to eq "texttext" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains \017
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    echo -n 'text\017text'
    """
    And a file named "spec/unescape_text_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run_command('aruba-test-cli') }
      before(:each) { stop_all_commands }

      it { expect(unescape_text(last_command.output)).to eq "texttext" }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Output contains \016
    Given an executable named "bin/aruba-test-cli" with:
    """
    #!/bin/bash
    echo -n 'text\016text'
    """
    And a file named "spec/unescape_text_spec.rb" with:
    """
    require 'spec_helper'

    RSpec.describe 'Run command', :type => :aruba do
      before(:each) { run_command('aruba-test-cli') }
      before(:each) { stop_all_commands }

      it { expect(unescape_text(last_command.output)).to eq "texttext" }
    end
    """
    When I run `rspec`
    Then the specs should all pass
