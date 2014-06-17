Feature: Flushing output

  In order to test processes that output a lot of data
  As a developer using Aruba
  I want to make sure that large amounts of output aren't buffered

  Scenario: A little output
    When I run `bash -c 'for ((c=0; c<256; c = c+1)); do echo -n "a"; done'`
    Then the output should contain "a"
    And the output should be 256 bytes long
    And the exit status should be 0

  Scenario: Tons of output
    Given the default aruba timeout is 10 seconds
    When I run `bash -c 'for ((c=0; c<65536; c = c+1)); do echo -n "a"; done'`
    Then the output should contain "a"
    And the output should be 65536 bytes long
    And the exit status should be 0

  Scenario: Tons of interactive output
    Given the default aruba timeout is 10 seconds
    When I run `bash -c 'read size; for ((c=0; c<$size; c = c+1)); do echo -n "a"; done'` interactively
    And I type "65536"
    Then the output should contain "a"
    And the output should be 65536 bytes long
    # And the exit status should be 0
