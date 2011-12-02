Feature: before_run hooks

  You can configure Aruba to run blocks of code before it runs
  each command.
  
  The command will be passed to the block.

  Scenario: Run a simple command with a before hook
    Given a file named "test.rb" with:
      """
      $: << '../../lib'
      require 'aruba/api'
      
      Aruba.configure do |config|
        config.before_run do |cmd|
          puts "about to run `#{cmd}`"
        end
      end
      
      include Aruba::Api
      run_simple("echo 'running'")
      puts all_stdout
      """
    When I run `ruby test.rb`
    Then it should pass with:
      """
      about to run `echo 'running'`
      running
      """
