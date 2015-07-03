Feature: After command hooks

  You can configure Aruba to run blocks of code after it has run
  a command. The command will be passed to the block.

  Scenario: Run a simple command with a after hook
    Given a file named "test.rb" with:
      """
      require 'aruba/api'

      Aruba.configure do |config|
        config.after :command do |cmd|
          puts "after the run of `#{cmd}`"
        end
      end

      include Aruba::Api
      setup_aruba
      run_simple("echo 'running'")
      puts last_command.stdout
      """
    When I run `ruby test.rb`
    Then it should pass with:
      """
      after the run of `echo 'running'`
      running
      """
