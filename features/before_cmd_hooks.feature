Feature: before_cmd hooks

  You can configure Aruba to run blocks of code before it runs
  each command.
  
  The command will be passed to the block.
  
  Scenario: Run a simple command with a before hook
    Given a file named "test.rb" with:
      """
      $: << '../../lib'
      require 'aruba/api'
      
      Aruba.configure do |config|
        config.before_cmd do |cmd|
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
  
  # This should move into a spec
  Scenario: Use something from the context where the command was run
    Given a file named "test.rb" with:
      """
      $: << '../../lib'
      require 'aruba/api'

      Aruba.configure do |config|
        config.before_cmd do |cmd|
          puts "I can see @your_context=#{@your_context}"
        end
      end

      class Test
        include Aruba::Api
        
        def test
          @your_context = "something"
          run_simple("echo 'running'")
          puts all_stdout
        end
      end
      
      Test.new.test
      """
    When I run `ruby test.rb`
    Then it should pass with:
      """
      I can see @your_context=something
      running
      """
