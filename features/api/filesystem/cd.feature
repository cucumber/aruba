Feature: Change current working directory

  If you need to run some code in a different directory you can use the `cd`
  command. It comes in two flavors:

  \* First can simply use `cd 'some-dir'`
  \* Second can use the block notation `cd('some-dir') { Dir.getwd }`

  If you chose to use the latter one, the result of your block is returned. The
  current working directory is only changed for the code inside the block -
  it's use is side effect free.

  Background:
    Given I use a fixture named "cli-app"

  Scenario: Existing directory
    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'cd to directory', :type => :aruba do
      before(:each) do 
        create_directory 'new_dir.d'
        cd 'new_dir.d'
      end

      before(:each) { run_command_and_stop 'pwd' }

      it { expect(last_command_started.output).to include 'new_dir.d' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Non-Existing directory
    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'cd to directory', :type => :aruba do
      before(:each) { cd 'new_dir.d' }
      before(:each) { run_command_and_stop 'pwd' }

      it { expect(last_command_started.output).to include 'new_dir.d' }
      it { expect(last_command_started).to be_executed_in_time }
    end
    """
    When I run `rspec`
    Then the specs should not pass

  Scenario: With block in it-block
    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'cd to directory', :type => :aruba do
      before(:each) do
        create_directory 'new_dir.d/subdir.d'
      end

      it do
        cd('new_dir.d/subdir.d') { expect(Dir.getwd).to include 'new_dir.d/subdir.d'  }
      end
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: With block in before-block

    Running `cd` with a block does not change:

    \* The current directory - `Dir.getwd`
    \* Aruba's current directory

    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'cd to directory', :type => :aruba do
      before(:each) do
        create_directory 'new_dir.d/subdir.d'
      end

      before :each do
        cd('new_dir.d/subdir.d') do
          # you code
        end
      end

      it { expect(Dir.getwd).not_to include 'new_dir.d/subdir.d' }
      it { expect(expand_path('.')).not_to include 'new_dir.d/subdir.d' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: The result of the block is returned

    If you need to run some code in a different directory, you can also use the
    block-notation of `cd`.

    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'cd to directory', :type => :aruba do
      before(:each) do
        create_directory 'new_dir.d/subdir.d'
      end

      before :each do
        @my_output = cd('new_dir.d/subdir.d') { Dir.getwd }
      end

      it { expect(@my_output).to include 'new_dir.d/subdir.d' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: It changes the PWD- and OLDPWD-ENV-variable for a given block

    If you need to run some code in a different directory, you can also use the
    block-notation of `cd`.

    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'cd to directory', :type => :aruba do
      before(:each) do
        create_directory 'new_dir.d'
      end

      before :each do
        cd('new_dir.d/') do
          @pwd    = ENV['PWD'] 
          @oldpwd = ENV['OLDPWD'] 
        end
      end

      it { expect(@pwd).to end_with 'new_dir.d' }
      it { expect(@oldpwd).to end_with 'cli-app' }
    end
    """
    When I run `rspec`
    Then the specs should all pass

  Scenario: Nested cd calls

    If you need to run some code in a different directory, you can also use the
    block-notation of `cd`.

    Given a file named "spec/cd_spec.rb" with:
    """ruby
    require 'spec_helper'

    RSpec.describe 'cd to directory', :type => :aruba do
      before(:each) do
        create_directory 'new_dir.d/subdir.d'
      end

      before :each do
        cd('new_dir.d') do
          @oldpwd_1 = ENV['OLDPWD'] 
          @pwd_1    = ENV['PWD'] 

          cd('subdir.d') do
            @oldpwd_2 = ENV['OLDPWD'] 
            @pwd_2    = ENV['PWD'] 
          end
        end
      end

      it { expect(@oldpwd_1).to be_end_with 'cli-app' }
      it { expect(@pwd_1).to be_end_with 'new_dir.d' }

      it { expect(@oldpwd_2).to be_end_with 'new_dir.d' }
      it { expect(@pwd_2).to be_end_with 'subdir.d' }
    end
    """
    When I run `rspec`
    Then the specs should all pass
