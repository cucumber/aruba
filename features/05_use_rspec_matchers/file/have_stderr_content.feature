Feature: Check if stderr can show content from a simple ruby file

  Background:
    Given a file named "hello_world.rb" with:
    """ruby
    # ruby 2.3.7
    warn 'hello world'
    """

  @announce
  Scenario: Test the file outputs the error
    Given I run `ruby hello_world.rb`
    Then the stderr should contain:
    """
    hello world
    """
