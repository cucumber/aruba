Feature: Flushing output

  In order to test processes that output a lot of data
  As a developer using Aruba
  I want to make sure that large amounts of output aren't buffered

  Scenario: A little output
    When I run `ruby -e 'puts :a.to_s * 256'`
    Then the output should contain "a"
    And the output should be 256 bytes long
    And the exit status should be 0

  Scenario: Tons of output
    When I run `ruby -e 'puts :a.to_s * 65536'`
    Then the output should contain "a"
    And the output should be 65536 bytes long
    And the exit status should be 0

  Scenario: Tons of interactive output
    When I interactively run `ruby -e 'len = gets.chomp; puts :a.to_s * len.to_i'`
    And I type "65536"
    Then the output should contain "a"
    And the output should be 65536 bytes long
    # And the exit status should be 0
